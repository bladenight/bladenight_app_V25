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

import 'app_settings/app_configuration_helper.dart';
import 'app_settings/globals.dart';
import 'firebase_options.dart';
import 'helpers/hive_box/adapter/color_adapter.dart';
import 'helpers/hive_box/app_server_config_db.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger.dart';
import 'helpers/preferences_helper.dart';
import 'main.init.dart';
import 'models/image_and_link.dart';

import 'pages/widgets/startup_widgets/app_root_widget.dart';
import 'providers/riverpod_observer/logging_observer.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
const String openRouteMapRoute = '/eventRoute';
const String openBladeguardOnSite = '/bgOnsite';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('FlutterError.onError main $details');
  };
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (!kReleaseMode) {
        FlutterError.onError = (details) {
          FlutterError.presentError(details);
        };
      }
      if (!kDebugMode && !kIsWeb) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };
        // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          if (Globals.logToCrashlytics) {
            FirebaseCrashlytics.instance
                .recordError(error, stack, fatal: false);
          }
          return true;
        };
      }
      initializeMappers();
      await Hive.initFlutter();
      Hive.registerAdapter(ColorAdapter());
      Hive.registerAdapter(ImageAndLinkAdapter());
      /*await Hive.openBox(hiveBoxSettingDbName);
      await Hive.openBox(hiveBoxLocationDbName);
      await Hive.openBox(hiveBoxServerConfigDBName);*/
      // turn off the # in the URLs on the web
      usePathUrlStrategy();
      runApp(
        ProviderScope(
          observers: [
            //LoggingObserver(),
          ],
          child: AppRootWidget(),
        ),
      );
    },
    (dynamic error, StackTrace stackTrace) {
      print('Application error 82: $error\n$stackTrace');
      if (!kDebugMode && !kIsWeb) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
      BnLog.error(
          className: 'main',
          methodName: 'runZonedGuarded',
          text: '$error\n$stackTrace');
    },
  );
}

Future<bool> initLogger() async {
  try {
    return BnLog.init();
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
