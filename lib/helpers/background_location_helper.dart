import 'package:flutter/cupertino.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../generated/l10n.dart';
import 'logger.dart';

class BackgroundGeolocationHelper {
  static Future<bool> resetOdoMeter(BuildContext context) async {
    await QuickAlert.show(
        context: context,
        showCancelBtn: true,
        type: QuickAlertType.warning,
        title: Localize.current.resetOdoMeterTitle,
        text: Localize.current.resetOdoMeter,
        confirmBtnText: Localize.of(context).yes,
        cancelBtnText: Localize.of(context).cancel,
        onConfirmBtnTap: () {
          bg.BackgroundGeolocation.setOdometer(0.0)
              .then((value) => true)
              .catchError((error) {
            BnLog.error(text: '[resetOdometer] ERROR: $error');
            if (!context.mounted) return false;
            Navigator.pop(context);
            return false;
          });
        });
    return false;
  }

  static Future<bool> openBatteriesSettings(BuildContext context) async {
    bool isIgnoring = await bg.DeviceSettings.isIgnoringBatteryOptimizations;

    bg.DeviceSettings.showIgnoreBatteryOptimizations()
        .then((bg.DeviceSettingsRequest request) async {
      if (!context.mounted) return;
      await QuickAlert.show(
          context: context,
          showCancelBtn: true,
          type: QuickAlertType.warning,
          title: Localize.current.ignoreBatteriesOptimisationTitle,
          text:
              '${Localize.current.isIgnoring}: $isIgnoring?${Localize.current.yes}:${Localize.current.no}\n${Localize.current.manufacturer}: ${request.manufacturer}\n${Localize.current.model}:${request.model}\n${Localize.current.version}:${request.version}\n${Localize.current.lastseen}: ${request.lastSeenAt}',
          confirmBtnText: Localize.current.change,
          cancelBtnText: Localize.current.cancel,
          onConfirmBtnTap: () async {
            await bg.DeviceSettings.show(request);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
    }).catchError((dynamic error) {
      BnLog.error(text: 'Batterieoptimierung fehlgeschlagen $error');
    });
    return false;
  }
}
