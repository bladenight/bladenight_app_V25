import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:universal_io/io.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../../models/external_app_message.dart';
import '../../providers/messages_provider.dart';
import '../device_info_helper.dart';
import '../hive_box/hive_settings_db.dart';
import '../logger/logger.dart';
import '../url_launch_helper.dart';
import '../uuid_helper.dart';

const MethodChannel channel = MethodChannel('bladenightbgnotificationchannel');

Future<void> initOneSignal() async {
  if (kIsWeb) {
    BnLog.info(text: 'Web - init OneSignal');
    await OnesignalHandler.initPushNotifications();
    return;
  }
  await Future.delayed(const Duration(seconds: 3)); //delay and wait
  if (Platform.isIOS) {
    BnLog.info(text: ' iOS - init OneSignal PushNotifications permissions OK');
    await OnesignalHandler.initPushNotifications();
    return;
  }
  //workaround for android 8.1 Nexus
  if (Platform.isAndroid &&
      await DeviceHelper.isAndroidGreaterOrEqualVersion(9)) {
    BnLog.info(
        text: 'Android is greater than V9 OneSignal - init Notifications');
    await OnesignalHandler.initPushNotifications();
    return;
  }

  BnLog.info(text: 'Onesignal not available ${Platform.version}');
}

class OnesignalHandler {
  OnesignalHandler._privateConstructor();

  static final OnesignalHandler _instance =
      OnesignalHandler._privateConstructor();

  static OnesignalHandler get instance => _instance;

  static Future<bool> initPushNotifications() async {
    try {
      //Remove this method to stop OneSignal Debugging
      if (kDebugMode) {
        OneSignal.Debug.setAlertLevel(OSLogLevel.none);
        OneSignal.Debug.setLogLevel(OSLogLevel.info);
      } else {
        OneSignal.Debug.setAlertLevel(OSLogLevel.none);
        OneSignal.Debug.setLogLevel(OSLogLevel.info);
      }

      OneSignal.initialize(oneSignalAppId);
      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      if (HiveSettingsDB.pushNotificationsEnabled) {
        var perm = await OneSignal.Notifications.requestPermission(false);
        if (perm == false) {
          //avoid permanent re-request on android
          HiveSettingsDB.setPushNotificationsEnabled(false);
        }
      }
      //OneSignal.consentGiven(true);
      //OneSignal.consentRequired(true);
      //Handler for silent notifications

      await OneSignal.User.pushSubscription.lifecycleInit();
      String userId = await OneSignal.User.getOnesignalId() ?? '';
      if (userId.isNotEmpty) HiveSettingsDB.setOneSignalId(userId);
      OneSignal.Location.setShared(false);

      OneSignal.User.pushSubscription.addObserver((changes) {
        //  print(changes.to.userId);
        BnLog.info(text: 'optIn:${OneSignal.User.pushSubscription.optedIn}');
        BnLog.info(text: 'ps_id:${OneSignal.User.pushSubscription.id}');
        BnLog.info(text: 'token:${OneSignal.User.pushSubscription.token}');
        BnLog.info(text: 'json:${changes.current.jsonRepresentation()}');

        String? oneSignalUserId = OneSignal.User.pushSubscription.id ?? '';
        if (oneSignalUserId.isNotEmpty) {
          HiveSettingsDB.setOneSignalId(oneSignalUserId);
        }
      });

      OneSignal.User.addObserver((state) {
        var userState = state.jsonRepresentation();
        print('OneSignal user changed: $userState');
      });

      setOneSignalChannels();

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        BnLog.info(
            text: 'OneSignal: notification opened: ${event.notification}');
        OnesignalHandler.handleNotificationOpenedResult(event);
      });

      OneSignal.Notifications.addPermissionObserver((state) {
        HiveSettingsDB.setPushNotificationsEnabled(state);
        BnLog.info(text: 'Accepted Onesignal permission: $state');
      });

      OneSignal.InAppMessages.addWillDisplayListener((event) {
        BnLog.info(text: 'inAppMessage ${event.message}');
      });

      OneSignal.Notifications.addClickListener((event) {
        //var json = action.jsonRepresentation();
        var clickName = event.result.actionId;
        var clickURL = event.notification.launchUrl;
        var title = event.notification.title;
        var body = event.notification.body;
        var message = ExternalAppMessage(
            uid: UUID.createUuid(),
            title: title ?? '',
            body: body ?? '',
            timeStamp: DateTime.now().millisecondsSinceEpoch,
            lastChange: DateTime.now().millisecondsSinceEpoch);
        message.url = clickURL;
        if (event.notification.buttons != null &&
            event.notification.buttons!.length == 1) {
          var button1 = event.notification.buttons!.first;
          message.button1Text = button1.text;
        }
        if (event.notification.buttons != null &&
            event.notification.buttons!.length == 2) {
          var button1 = event.notification.buttons!.first;
          var button2 = event.notification.buttons!.last;
          message.button1Text = button1.text;
          message.button2Text = button2.text;
        }
        ProviderContainer().read(messagesLogicProvider).addMessage(message);

        if (clickName != null &&
            clickName.toLowerCase() == 'yes' &&
            clickURL != null &&
            clickURL != '') {
          try {
            Launch.launchUrlFromString(clickURL, 'ext. Link');
          } catch (error) {
            BnLog.error(
                text:
                    'Error setInAppMessageClickedHandler ${event.jsonRepresentation()}',
                exception: error);
          }
        }
      });

      channel.setMethodCallHandler((call) async {
        receivedBgRemoteMessage(call);
      });
    } catch (e) {
      BnLog.error(text: 'Error initPushNotifications', exception: e);
      return false;
    }
    return true;
  }

  static Future<void> setOneSignalChannels() async {
    if (HiveSettingsDB.pushNotificationsEnabled == false) {
      HiveSettingsDB.setOneSignalRegisterBladeGuardPush(false);
      await OnesignalHandler.registerPushAsBladeGuard(false, '');
      HiveSettingsDB.setRcvSkatemunichInfos(false);
      await OnesignalHandler.registerSkateMunichInfo(false);
      await OneSignal.User.pushSubscription.optOut();
    } else {
      //allow onesignal
      await OneSignal.User.pushSubscription.optIn();
      //OneSignal.User.addAlias('app_id', DeviceId.appId); error claimed by another user
      //OneSignal.User.addAlias('team', HiveSettingsDB.bgTeam);
    }
    if (HiveSettingsDB.oneSignalRegisterBladeGuardPush &&
        HiveSettingsDB.bladeguardSHA512Hash.isNotEmpty) {
      OneSignal.login(HiveSettingsDB.bladeguardSHA512Hash);
    }

    var optedIn = OneSignal.User.pushSubscription.optedIn;
    BnLog.info(text: 'setOneSignalChannels optIn is $optedIn');
  }

  static Future<void> unRegisterPushAsBladeGuard() async {
    await OnesignalHandler.registerPushAsBladeGuard(false, '');
    await OnesignalHandler.registerSkateMunichInfo(false);
  }

  static Future<void> registerPushAsBladeGuard(
      bool value, String teamId) async {
    HiveSettingsDB.setOneSignalRegisterBladeGuardPush(value);
    if (value == false) {
      await OneSignal.User.removeTag('IsBladeguard').catchError((err) {
        BnLog.error(text: 'unregister IsBladeguard error $err', exception: err);
      });
      return;
    }

    Map<String, String> map = {
      'IsBladeguard': value ? teamId : '',
    };
    BnLog.info(text: 'register IsBladeguard value $value $teamId');
    await OneSignal.User.pushSubscription.optIn();
    BnLog.info(
        text: 'Bladeguard logged in to OneSignal',
        methodName: 'registerPushAsBladeGuard');
    OneSignal.User.addTags(map).catchError((err) {
      BnLog.error(text: 'register IsBladeguard error $err', exception: err);
    });
  }

  static Future<void> registerSkateMunichInfo(bool value) async {
    HiveSettingsDB.setRcvSkatemunichInfos(value);
    if (value == false) {
      OneSignal.User.removeTag('RcvSkateMunichInfos').catchError((err) {
        BnLog.error(
            text: 'unregisterSkateMunichInfo error $err', exception: err);
      });
      return;
    }

    BnLog.info(text: 'registerSkateMunichInfo  $value');
    OneSignal.User.addTagWithKey('RcvSkateMunichInfos', value.toString())
        .catchError((err) {
      BnLog.error(text: 'registerSkateMunichInfo error $err', exception: err);
    });
  }

  static void handleNotificationOpenedResult(
      OSNotificationWillDisplayEvent result) async {
    var data = result.notification.additionalData;
    var title = result.notification.title;
    var body = result.notification.body;
    var buttons = result.notification.buttons;

    var message = ExternalAppMessage(
        uid: UUID.createUuid(),
        title: title ?? '',
        body: body ?? '',
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        lastChange: DateTime.now().millisecondsSinceEpoch);

    if (buttons != null && buttons.length >= 1) {
      var button1 = buttons.first;
      message.button1Text = button1.text;
      if (data != null) {
        if (data.keys.contains('url')) {
          message.url = data['url'];
        }
      }
      ProviderContainer().read(messagesLogicProvider).addMessage(message);
      await QuickAlert.show(
          showCancelBtn: true,
          cancelBtnText: Localize.current.cancel,
          context: rootNavigatorKey.currentContext!,
          title: title ?? Localize.current.notification,
          text: body ?? '',
          confirmBtnText: button1.text,
          type: QuickAlertType.info,
          onConfirmBtnTap: () {
            if (data != null) {
              if (data.keys.contains('url')) {
                message.url = data['url'];
                Launch.launchUrlFromString(data['url'], title ?? 'ext. Link');
              }
            }
            return rootNavigatorKey.currentState?.pop();
          });
    }
    //2 buttons
    if (buttons != null && buttons.length == 2) {
      var button1 = buttons.first;
      var button2 = buttons.last;
      message.button1Text = button1.text;
      message.button2Text = button2.text;
      if (data != null) {
        if (data.keys.contains('url')) {
          message.url = data['url'];
        }
      }
      ProviderContainer().read(messagesLogicProvider).addMessage(message);
      await QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          title: title ?? Localize.current.notification,
          text: body ?? '',
          confirmBtnText: button1.text,
          cancelBtnText: button2.text,
          type: QuickAlertType.info,
          onConfirmBtnTap: () {
            if (data != null) {
              if (data.keys.contains('url')) {
                message.url = data['url'];
                Launch.launchUrlFromString(data['url'], title ?? 'ext. Link');
              }
            }
            return rootNavigatorKey.currentState?.pop();
          });
    }
  }

  @pragma('vm:entry-point')
  static void receivedBgRemoteMessage(MethodCall call) async {
    try {
      print('receivedBgRemoteMessage remote notification received');
      ProviderContainer().read(messagesLogicProvider).addMessage(
          ExternalAppMessage(
              uid: UUID.createUuid(),
              title: call.arguments,
              body: call.toString(),
              timeStamp: DateTime.now().millisecondsSinceEpoch,
              lastChange: DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      BnLog.error(
          className: 'onesignal_handler',
          methodName: 'receivedBgRemoteMessage',
          text: '$e');
    }
  }
}
