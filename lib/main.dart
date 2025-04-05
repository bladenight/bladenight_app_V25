@MappableLib(generateInitializerForScope: InitializerScope.package)
library main;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart'
    show TalkerRiverpodObserver;
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

import 'app_settings/app_configuration_helper.dart';
import 'app_settings/globals.dart';
import 'app_settings/server_connections.dart';
import 'firebase_options.dart';
import 'helpers/hive_box/adapter/color_adapter.dart';
import 'helpers/hive_box/adapter/images_and_links_adapter.dart';
import 'helpers/hive_box/app_server_config_db.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger/logger.dart';
import 'helpers/preferences_helper.dart';
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
      initCrashLogs();
      initializeMappers();

      //HomeWidget.registerInteractivityCallback(backgroundCallback);
      await Hive.initFlutter();
      Hive.registerAdapter(ColorAdapter());
      //needed for old stuff HiveBinaryReader ID 87 (55+32)
      Hive.registerAdapter(ImageAndLinkAdapter());
      //open hive boxes in app_start

      // turn off the # in the URLs on the web
      usePathUrlStrategy();

      /*await SentryFlutter.init((options) {
        options.dsn =
            'https://260152b2325af41400820edd53e3a54c@o4507936224706560.ingest.de.sentry.io/4507936226541648';
        https: //examplePublicKey@o0.ingest.sentry.io/0';
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
                    LoggingObserver(),
                  ],
                  child: AppRootWidget(),
                ),
              ));
*/
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
    },
    (dynamic error, StackTrace stackTrace) {
      print(
          '${DateTime.now().toIso8601String()} Application error 111: \n$error\n$stackTrace');
      if (!kDebugMode && !kIsWeb && !localTesting) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
      BnLog.error(
          className: 'main',
          methodName: 'runZonedGuarded',
          text: '$error\n$stackTrace');
    },
  );
}

void initCrashLogs() async {
  if (kDebugMode) {
    FlutterError.onError = (details) {
      talker.log(
        details.exceptionAsString(),
        logLevel: LogLevel.critical,
        stackTrace: details.stack,
      );
      FlutterError.presentError(details);
    };
  } else if (!kDebugMode && !kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (details) {
      talker.log(
        details.exceptionAsString(),
        logLevel: LogLevel.critical,
        stackTrace: details.stack,
      );
      if (Globals.logToCrashlytics) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      if (Globals.logToCrashlytics) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
      }
      talker.handle(error, stack, 'PlatformDispatcher Instance Error');
      return true;
    };
    talker.log('BladenightApp started');
    talker.configure(logger: TalkerLogger());
  }
}

Future<bool> initLogger() async {
  try {
    return await BnLog.init();
  } catch (e) {
    print('Logger init failed --> $e');
    return false;
  }
}

void initSettings() async {
  try {
    globalSharedPrefs = await SharedPreferences.getInstance();
    PreferencesHelper.getImagesAndLinksPref();
    if (HiveSettingsDB.firstStart2421 && globalSharedPrefs != null && !kIsWeb) {
      var restApiLink = ServerConfigDb.restApiLinkBg;
      globalSharedPrefs?.setString(ServerConfigDb.restApiLinkKey, restApiLink);
      var onSite = HiveSettingsDB.onsiteGeoFencingActive;
      globalSharedPrefs?.setBool(HiveSettingsDB.setOnsiteGeoFencingKey, onSite);
      var mail = HiveSettingsDB.bladeguardEmail;
      globalSharedPrefs?.setString(HiveSettingsDB.bladeguardEmailKey, mail);
      var val = HiveSettingsDB.bladeguardBirthday;
      var bdStr =
          '${val.year}-${val.month.toString().padLeft(2, '0')}-${val.day.toString().padLeft(2, '0')}';
      globalSharedPrefs?.setString(HiveSettingsDB.bladeguardBirthdayKey, bdStr);
      var oneSignalId = HiveSettingsDB.oneSignalId;
      globalSharedPrefs?.setString(HiveSettingsDB.oneSignalId, oneSignalId);
      globalSharedPrefs?.setBool('eventConfirmed', false);
      // uncomment for testing headlessSetBladeguardOnSite(true);
      //
      HiveSettingsDB.setFirstStart2421(false);
    }
  } catch (_) {}
}
