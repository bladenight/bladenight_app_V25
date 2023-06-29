import 'dart:async';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../deviceid_helper.dart';
import '../hive_box/hive_settings_db.dart';
import '../url_launch_helper.dart';

Future<bool> initPushNotifications() async {
  try {
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.error);
    } else {
      OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);
    }

    if (HiveSettingsDB.pushNotificationsEnabled == false) {
      await OneSignal.shared.disablePush(true);
      return true;
    } else {
      //allow onesignal
      await OneSignal.shared.disablePush(false);
    }

    await OneSignal.shared.setLocationShared(false);
    await OneSignal.shared.setAppId(oneSignalAppId).catchError((error) {
      if (kIsWeb) {
        FLog.error(
            text: 'Error OneSignal.shared.setAppId $error', exception: error);
      }
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('"OneSignal: notification opened: $result');
      OnesignalHandler.handleNotificationOpenedResult(result);
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      //var json = action.jsonRepresentation();
      var clickName = action.clickName;
      var clickURL = action.clickUrl;
      //var firstClick = action.firstClick;
      /*  OSInAppMessageAction(Map<String, dynamic> json) {
    this.clickName = json["click_name"];
    this.clickUrl = json["click_url"];
    this.firstClick = json["first_click"] as bool;
    this.closesMessage = json["closes_message"] as bool;
  }*/

      if (clickName != null &&
          clickName.toLowerCase() == 'yes' &&
          clickURL != null &&
          clickURL != '') {
        try {
          Launch.launchUrlFromString(clickURL);
        } catch (error) {
          if (kIsWeb) {
            FLog.error(
                text:
                    'Error setInAppMessageClickedHandler ${action.jsonRepresentation()}',
                exception: error);
          }
        }
      }
    });
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
      HiveSettingsDB.setPushNotificationsEnabled(accepted);
      print('Accepted permission: $accepted');
    });
  } catch (e) {
    if (!kIsWeb) FLog.error(text: 'Error initPushNotifications', exception: e);
    return false;
  }
  return true;
}

class OnesignalHandler {
  OnesignalHandler._privateConstructor();

  static final OnesignalHandler _instance =
      OnesignalHandler._privateConstructor();

  static OnesignalHandler get instance => _instance;

  static Future<void> registerPushAsBladeGuard(bool value, int teamId) async {
    await OneSignal.shared.sendTag('IsBladeguard', value).catchError((err) {
      if (!kIsWeb) {
        FLog.error(text: 'register IsBladeguard error $err', exception: err);
      }
      return <String, dynamic>{};
    });
    await registerBladeGuardClick(teamId);
  }

  static Future<void> registerBladeGuardClick(int value) async {
    await OneSignal.shared.sendTag('BladeguardClick', value).catchError((err) {
      if (!kIsWeb) {
        FLog.error(text: 'registerSkateMunichInfo error $err', exception: err);
      }
      return <String, dynamic>{};
    });
  }

  static Future<void> registerSkateMunichInfo(bool value) async {
    await OneSignal.shared
        .sendTag('RcvSkateMunichInfos', value)
        .catchError((err) {
      if (!kIsWeb) {
        FLog.error(text: 'registerSkateMunichInfo error $err', exception: err);
      }
      return <String, dynamic>{};
    });
  }

  void addOneSignalNotification(OSNotificationOpenedResult result) {
    OnesignalHandler.handleNotificationOpenedResult(result);
  }

  static void handleNotificationOpenedResult(
      OSNotificationOpenedResult result) async {
    var data = result.notification.additionalData;
    var title = result.notification.title;
    var body = result.notification.body;
    var buttons = result.notification.buttons;
    CustomButton? buttonres;
    if (buttons != null && buttons.length == 1) {
      var button1 = buttons.first;
      buttonres = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: title ?? Localize.current.notification,
          text: body ?? '',
          positiveButtonTitle: button1.text);
    }
    //2 buttons
    if (buttons != null && buttons.length == 2) {
      var button1 = buttons.first;
      var button2 = buttons.last;
      buttonres = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: title ?? Localize.current.notification,
          text: body ?? '',
          positiveButtonTitle: button1.text,
          negativeButtonTitle: button2.text);
    }
    if (buttonres != null &&
        data != null &&
        buttonres == CustomButton.positiveButton) {
      var devId = await DeviceId.getId;
      if (data.keys.contains('url')) {
        Launch.launchUrlFromString(data['url'] + '/?id=$devId');
      }
    }
  }
}
