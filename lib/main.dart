@MappableLib(generateInitializerForScope: InitializerScope.package)
library main;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart' show SentryFlutter;
import 'package:talker/talker.dart' show Talker;
import 'package:talker_flutter/talker_flutter.dart' show TalkerFlutter;
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart'
    show TalkerRiverpodObserver;
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

import 'app_settings/app_constants.dart';
import 'app_settings/server_connections.dart';
import 'helpers/hive_box/adapter/color_adapter.dart';
import 'helpers/hive_box/adapter/images_and_links_adapter.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger/log_level.dart' show LogLevel;
import 'helpers/logger/logger.dart';
import 'main.init.dart';

import 'pages/widgets/startup_widgets/app_root_widget.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
const String openRouteMapRoute = '/eventRoute';
const String openBladeguardOnSite = '/bgOnsite';
late Talker talker;

@pragma('vm:entry-point')
FutureOr<void> backgroundCallback(Uri? data) async {
  if (data == null) {
    return;
  }
}

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      talker = TalkerFlutter.init();
      initializeMappers();

      //HomeWidget.registerInteractivityCallback(backgroundCallback);
      await Hive.initFlutter();
      await IsolatedHive.initFlutter();
      Hive.registerAdapter(ColorAdapter());
      //needed for old stuff HiveBinaryReader ID 87 (55+32)
      Hive.registerAdapter(ImageAndLinkAdapter());

      //open hive boxes on app_start
      await Hive.openBox(hiveBoxSettingDbName);
      await IsolatedHive.openBox(isolatedHiveDbName);

      // turn off the # in the URLs on the web
      usePathUrlStrategy();
      // init crashlytics
      if (kIsWeb ||
          (HiveSettingsDB.chrashlyticsEnabled &&
                  HiveSettingsDB.loggerLogLevel == LogLevel.verbose ||
              HiveSettingsDB.loggerLogLevel == LogLevel.debug)) {
        await SentryFlutter.init((options) {
          options.replay.sessionSampleRate = 1.0;
          options.replay.onErrorSampleRate = 1.0;
          options.enableNativeCrashHandling = true;
          options.enableMemoryPressureBreadcrumbs = true;
          options.enableWatchdogTerminationTracking = true;
          options.dsn = sentryDSN;
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
          // We recommend adjusting this value in production.
          options.tracesSampleRate = 1.0;
          // The sampling rate for profiling is relative to tracesSampleRate
          // Setting to 1.0 will profile 100% of sampled transactions:
          // Note: Profiling alpha is available for iOS and macOS since SDK version 7.12.0
          options.profilesSampleRate = 1.0;
        },
            appRunner: () => runApp(
                  ProviderScope(
                    observers: [
                      // LoggingObserver(),
                    ],
                    child: AppRootWidget(),
                  ),
                ));
      } else {
        runApp(
          ProviderScope(
            observers: [
              if (riverPodDebugLog)
                TalkerRiverpodObserver(
                  talker: talker,
                  settings: TalkerRiverpodLoggerSettings(
                    enabled: true,
                    printStateFullData: false,
                    printProviderAdded: true,
                    printProviderUpdated: true,
                    printProviderDisposed: true,
                    printProviderFailed: true,
                  ),
                ),
              //LoggingObserver(),
            ],
            child: AppRootWidget(),
          ),
        );
      }
    },
    (dynamic error, StackTrace stackTrace) {
      print(
          '${DateTime.now().toIso8601String()} Application error 115: \n$error\n$stackTrace');
      if (!kDebugMode &&
          !kIsWeb &&
          !localTesting &&
          HiveSettingsDB.chrashlyticsEnabled) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
      BnLog.error(
          className: 'main', methodName: 'runZonedGuarded', text: '$error');
    },
  );
}

Future<bool> initLogger() async {
  try {
    return await BnLog.init();
  } catch (e) {
    print('Logger init failed --> $e');
    return false;
  }
}
