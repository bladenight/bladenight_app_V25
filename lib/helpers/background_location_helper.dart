import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '../generated/l10n.dart';
import 'logger.dart';

class BackgroundGeolocationHelper {
  static Future<bool> resetOdoMeter(BuildContext context) async {
    var odometerResetResult = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.current.resetOdoMeterTitle,
        text: Localize.current.resetOdoMeter,
        iconStyle: IconStyle.warning,
        positiveButtonTitle: Localize.of(context).yes,
        negativeButtonTitle: Localize.of(context).cancel);
    if (odometerResetResult == CustomButton.positiveButton) {
      bg.BackgroundGeolocation.setOdometer(0.0)
          .then((value) => true)
          .catchError((error) {
        if (!kIsWeb) BnLog.error(text: '[resetOdometer] ERROR: $error');
        return false;
      });
    }
    return false;
  }

  static Future<bool> openBatteriesSettings() async {
    bool isIgnoring = await bg.DeviceSettings.isIgnoringBatteryOptimizations;

    bg.DeviceSettings.showIgnoreBatteryOptimizations()
        .then((bg.DeviceSettingsRequest request) async {
      var res = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: Localize.current.ignoreBatteriesOptimisationTitle,
          text:
              '${Localize.current.isIgnoring}: $isIgnoring?${Localize.current.yes}:${Localize.current.no}\n${Localize.current.manufacturer}: ${request.manufacturer}\n${Localize.current.model}:${request.model}\n${Localize.current.version}:${request.version}\n${Localize.current.lastseen}: ${request.lastSeenAt}',
          positiveButtonTitle: Localize.current.change,
          negativeButtonTitle: Localize.current.cancel);
      if (res == CustomButton.positiveButton) {
        return await bg.DeviceSettings.show(request);
      }
    }).catchError((dynamic error) {
      BnLog.error(text: 'Batterieoptimierung fehlgeschlagen $error');
      return false;
    });
    return false;
  }
}
