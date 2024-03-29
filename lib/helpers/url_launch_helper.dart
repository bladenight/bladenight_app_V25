import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'logger.dart';

class Launch {
  static void launchUrlFromString(String url,
      {LaunchMode mode = LaunchMode.externalApplication}) {
    return runZonedGuarded(() async {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: mode);
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
        await launchUrl(uri, mode: mode);
      } else {
        BnLog.error(className: 'Launch', text: 'Could not launch $uri');
      }
    }, (error, stack) {
      BnLog.error(
          className: 'Guarded launchUrlFromUrl', text: 'Could not launch $uri');
    });
  }
}
