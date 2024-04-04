import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../generated/l10n.dart';
import '../main.dart';
import '../pages/widgets/scroll_quick_alert.dart';
import 'logger.dart';

class Launch {
  static void launchUrlFromString(String url,
      {LaunchMode mode = LaunchMode.externalApplication}) {
    return runZonedGuarded(() async {
      if (await canLaunchUrlString(url)) {
        var res = true;
        if (mode == LaunchMode.externalApplication &&
            navigatorKey.currentContext != null) {
          res = await ScrollQuickAlert.show(
              context: navigatorKey.currentContext!,
              title: Localize.current.leaveAppWarningTitle,
              text: '${Localize.current.leaveAppWarning}\n$url',
              type: QuickAlertType.info,
              onConfirmBtnTap: () {
                navigatorKey.currentState?.pop(true);
              },
              onCancelBtnTap: () {
                navigatorKey.currentState?.pop(false);
              });
        }
        if (res) await launchUrlString(url, mode: mode);
      } else {
        if (!kIsWeb) {
          BnLog.error(className: 'Launch', text: 'Could not launch $url');
        }
      }
    }, (error, stack) {
      BnLog.error(
          className: 'Guarded launchUrlFromString',
          text: 'Could not launch $url');
    });
  }

  static void launchUrlFromUri(Uri uri,
      {LaunchMode mode = LaunchMode.externalApplication}) {
    return runZonedGuarded(() async {
      if (await canLaunchUrl(uri)) {
        var res = true;
        if (mode == LaunchMode.externalApplication &&
            navigatorKey.currentContext != null) {
          res = await ScrollQuickAlert.show(
              context: navigatorKey.currentContext!,
              title: Localize.current.leaveAppWarningTitle,
              text: '${Localize.current.leaveAppWarning}\n${uri.toString()}',
              type: QuickAlertType.confirm,
              onConfirmBtnTap: () {
                navigatorKey.currentState?.pop(true);
              },
              onCancelBtnTap: () {
                navigatorKey.currentState?.pop(false);
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
