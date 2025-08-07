import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../generated/l10n.dart';
import '../main.dart';
import 'hive_box/hive_settings_db.dart';
import 'logger/logger.dart';

class Launch {
  static void launchUrlFromString(String inUrl, String linkDescription,
      {LaunchMode mode = LaunchMode.externalApplication, addData = false}) {
    return runZonedGuarded(() async {
      var callUrl = inUrl.toString();
      if (addData) {
        callUrl += '?email=${HiveSettingsDB.bladeguardEmail}';
        DateFormat df = DateFormat('yyyy-MM-dd');
        var ds = df.format(HiveSettingsDB.bladeguardBirthday);
        callUrl += '&birth=$ds';
      }

      if (await canLaunchUrlString(callUrl)) {
        var res = true;
        if (!kIsWeb &&
            mode == LaunchMode.externalApplication &&
            rootNavigatorKey.currentContext != null) {
          res = await QuickAlert.show(
              showCancelBtn: true,
              cancelBtnText: Localize.current.cancel,
              context: rootNavigatorKey.currentContext!,
              title: Localize.current.leaveAppWarningTitle,
              text: Localize.current.leaveAppWarning(linkDescription, inUrl),
              type: QuickAlertType.info,
              onConfirmBtnTap: () {
                rootNavigatorKey.currentState?.pop(true);
              },
              onCancelBtnTap: () {
                rootNavigatorKey.currentState?.pop(false);
              });
        }
        if (res) await launchUrlString(callUrl, mode: mode);
      } else {
        if (!kIsWeb) {
          BnLog.error(className: 'Launch', text: 'Could not launch $callUrl');
        }
      }
    }, (error, stack) {
      BnLog.error(
          className: 'Guarded launchUrlFromString',
          text: 'Could not launch $inUrl');
    });
  }

  static void launchUrlFromUri(Uri uri, String linkDescription,
      {LaunchMode mode = LaunchMode.externalApplication, addData = false}) {
    return runZonedGuarded(() async {
      if (await canLaunchUrl(uri)) {
        var res = true;
        if (!kIsWeb &&
            mode == LaunchMode.externalApplication &&
            rootNavigatorKey.currentContext != null) {
          res = await QuickAlert.show(
              showCancelBtn: true,
              cancelBtnText: Localize.current.cancel,
              context: rootNavigatorKey.currentContext!,
              title: Localize.current.leaveAppWarningTitle,
              text: Localize.current
                  .leaveAppWarning(linkDescription, uri.toString()),
              type: QuickAlertType.confirm,
              onConfirmBtnTap: () {
                rootNavigatorKey.currentState?.pop(true);
              },
              onCancelBtnTap: () {
                rootNavigatorKey.currentState?.pop(false);
              });
        }
        if (res) await launchUrl(uri, mode: mode);
      } else {
        BnLog.error(className: 'Launch', text: 'Could not launch $uri');
      }
    }, (error, stack) {
      BnLog.error(
          className: 'Guarded launchUrlFromUrl', text: 'Could not launch $uri');
    });
  }
}
