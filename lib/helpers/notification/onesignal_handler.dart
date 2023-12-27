import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../models/message.dart';
import '../../providers/messages_provider.dart';
import '../deviceid_helper.dart';
import '../hive_box/hive_settings_db.dart';
import '../logger.dart';
import '../url_launch_helper.dart';
import '../uuid_helper.dart';

const MethodChannel channel = MethodChannel('bladenightbgnotificationchannel');

class OnesignalHandler {
  OnesignalHandler._privateConstructor() {
    OneSignal.User.pushSubscription.addObserver((changes) {
      //  print(changes.to.userId);
      String? userId = OneSignal.User.pushSubscription.id ?? '';

      HiveSettingsDB.setOneSignalId(userId);
    });
  }

  static final OnesignalHandler _instance =
      OnesignalHandler._privateConstructor();

  static OnesignalHandler get instance => _instance;

  static Future<bool> initPushNotifications() async {
    try {
      //Remove this method to stop OneSignal Debugging
      if (kDebugMode) {
        OneSignal.Debug.setAlertLevel(OSLogLevel.none);
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      } else {
        OneSignal.Debug.setAlertLevel(OSLogLevel.none);
        OneSignal.Debug.setLogLevel(OSLogLevel.none);
      }

      OneSignal.initialize(oneSignalAppId);
      OneSignal.User.pushSubscription.lifecycleInit();
      OneSignal.Location.setShared(false);

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
        var message = Message(
            uid: UUID.createUuid(),
            title: title ?? '',
            body: body ?? '',
            timeStamp: DateTime.now().millisecondsSinceEpoch);
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
            Launch.launchUrlFromString(clickURL);
          } catch (error) {
            BnLog.error(
                text:
                    'Error setInAppMessageClickedHandler ${event.jsonRepresentation()}',
                exception: error);
          }
        }
      });
      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.Notifications.requestPermission(true);
      //Handler for silent notifications
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
      HiveSettingsDB.setBladeGuardClick(false);
      await OnesignalHandler.registerPushAsBladeGuard(false, 0);
      HiveSettingsDB.setRcvSkatemunichInfos(false);
      await OnesignalHandler.registerSkateMunichInfo(false);
      await OneSignal.User.pushSubscription.optOut();
    } else {
      //allow onesignal
      await OneSignal.User.pushSubscription.optIn();
    }
    var optedIn = OneSignal.User.pushSubscription.optedIn;
    BnLog.info(text: 'setOneSignalChannels optIn is $optedIn');
  }

  static Future<void> registerPushAsBladeGuard(bool value, int teamId) async {
    Map<String, String> map = {
      'IsBladeguard': value ? teamId.toString() : '0',
    };
    BnLog.info(text: 'register IsBladeguard value $value $teamId');
    OneSignal.User.addTags(map).catchError((err) {
      BnLog.error(text: 'register IsBladeguard error $err', exception: err);
    });
  }

  static Future<void> registerSkateMunichInfo(bool value) async {
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

    var message = Message(
        uid: UUID.createUuid(),
        title: title ?? '',
        body: body ?? '',
        timeStamp: DateTime.now().millisecondsSinceEpoch);

    CustomButton? buttonResult;
    if (buttons != null && buttons.length == 1) {
      var button1 = buttons.first;
      message.button1Text = button1.text;
      buttonResult = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: title ?? Localize.current.notification,
          text: body ?? '',
          positiveButtonTitle: button1.text);
    }
    //2 buttons
    if (buttons != null && buttons.length == 2) {
      var button1 = buttons.first;
      var button2 = buttons.last;
      message.button1Text = button1.text;
      message.button2Text = button2.text;
      buttonResult = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: title ?? Localize.current.notification,
          text: body ?? '',
          positiveButtonTitle: button1.text,
          negativeButtonTitle: button2.text);
    }
    if (buttonResult != null &&
        data != null &&
        buttonResult == CustomButton.positiveButton) {
      var devId = await DeviceId.getId;
      if (data.keys.contains('url')) {
        message.url = data['url'] + '/?id=$devId';
        Launch.launchUrlFromString(data['url'] + '/?id=$devId');
      }
    }
    ProviderContainer().read(messagesLogicProvider).addMessage(message);
  }

  @pragma('vm:entry-point')
  static void receivedBgRemoteMessage(MethodCall call) async {
    try {
      print('remote notification received');
      ProviderContainer().read(messagesLogicProvider).addMessage(Message(
          uid: UUID.createUuid(),
          title: call.arguments,
          body: 'Test',
          timeStamp: DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      BnLog.error(
          className: 'onesignal_handler',
          methodName: 'receivedBgRemoteMessage',
          text: '$e');
    }
  }
}
