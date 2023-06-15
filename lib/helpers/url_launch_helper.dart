import 'dart:async';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Launch {
  static void launchUrlFromString(String url) {
    return runZonedGuarded(() async {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        if (!kIsWeb) {
          FLog.error(className: 'Launch', text: 'Could not launch $url');
        }
      }
    }, (error, stack) {
      FLog.error(
          className: 'Guarded launchUrlFromString', text: 'Could not launch $url');
    });
  }

  static void launchUrlFromUrl(Uri url) {
    return runZonedGuarded(() async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!kIsWeb) {
          FLog.error(className: 'Launch', text: 'Could not launch $url');
        }
      }
    }, (error, stack) {
      FLog.error(
          className: 'Guarded launchUrlFromUrl', text: 'Could not launch $url');
    });
  }
}
