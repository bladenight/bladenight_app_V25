@MappableLib(generateInitializerForScope: InitializerScope.package)
library main;

import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings/app_configuration_helper.dart';
import 'app_settings/server_connections.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'helpers/export_import_data_helper.dart';
import 'helpers/hive_box/hive_settings_db.dart';
import 'helpers/logger.dart';
import 'helpers/notification/notification_helper.dart';
import 'helpers/preferences_helper.dart';
import 'main.init.dart';
import 'pages/home_screen.dart';
import 'pages/widgets/intro_slider.dart';
import 'pages/widgets/route_name_dialog.dart';
import 'providers/shared_prefs_provider.dart';

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
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
          return true;
        };
      }
      initializeMappers();
      await Hive.initFlutter();
      await Hive.openBox('settings');
      await initLogger();
      if (!kIsWeb) {
        await initNotifications();
      }
      initSettings();
      runApp(const ProviderScope(
          child: InheritedConsumer(child: BladeNightApp())));

      /* if (Platform.isAndroid) {
        /// Register BackgroundGeolocation headless-task.
        bg.BackgroundGeolocation.registerHeadlessTask(
            backgroundGeolocationHeadlessTask);

        /// Register BackgroundFetch headless-task.
        //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
      }*/
    },
    (dynamic error, StackTrace stackTrace) {
      print('Application error 84: $error\n$stackTrace');
      if (!kDebugMode && !kIsWeb) {
        //FirebaseCrashlytics.instance.recordError(error, stackTrace);
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
    await BnLog.init();
    BnLog.info(text: 'logger initialized');
  } catch (e) {
    print(e);
    return false;
  }
  return true;
}

Future<bool> initNotifications() async {
  try {
    await NotificationHelper().initialiseNotifications();
  } catch (e) {
    print(e);
    return false;
  }
  return true;
}

void initSettings() async {
  globalSharedPrefs = await SharedPreferences.getInstance();
  PreferencesHelper.getImagesAndLinksPref();
}

class BladeNightApp extends StatelessWidget {
  const BladeNightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Localize.of(context).closeApp),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(Localize.of(context).yes),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(Localize.of(context).no),
                ),
              ],
            );
          },
        );
        return;
      },
      child: MediaQuery.fromView(
        view: View.of(context),
        child: CupertinoAdaptiveTheme(
          light: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: context.watch(ThemePrimaryColor.provider) ??
                  systemPrimaryDefaultColor),
          dark: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: context.watch(ThemePrimaryDarkColor.provider) ??
                systemPrimaryDefaultColor,
          ),
          initial: HiveSettingsDB.adaptiveThemeMode,
          builder: (theme) => CupertinoApp(
              onGenerateRoute: (uriString) {
                BnLog.info(text: 'onGenerateRoute requested ${uriString.name}');
                if (uriString.name == null ) return null;
                    if(uriString.name!.startsWith('/showroute')) {
                  return CupertinoPageRoute(
                      builder: (context) => RouteNameDialog(
                            routeName: uriString.name
                                .toString()
                                .replaceAll('/showroute?', '')
                                .trim(),
                          ),
                      fullscreenDialog: true);
                }
                if (uriString.name!.contains('?data=')) {
                  importData(context, uriString.name!);
                } else if (uriString.name!.contains('?addFriend')) {
                  //tabController.index = 3;
                  addFriendWithCodeFromUrl(context, uriString.name!).then((value) => null);
                  
                } else if (uriString.name!.contains('?$specialCode=1')) {
                  HiveSettingsDB.setSpecialRightsPrefs(true);
                } else if (uriString.name!.contains('?$specialCode=0')) {
                  HiveSettingsDB.setSpecialRightsPrefs(false);
                }
                return null;
              },
              title: 'BladeNight München',
              debugShowCheckedModeBanner: false,
              theme: theme,
              localizationsDelegates: const [
                //AppLocalizations.delegate,
                Localize.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: Localize.delegate.supportedLocales,
              // AppLocalizations.supportedLocales,
              home: const HomeScreen(),
              routes: <String, WidgetBuilder>{
                IntroScreen.openIntroRoute: (BuildContext context) =>
                    const IntroScreen(),
                HomeScreen.routeName: (BuildContext context) =>
                    const HomeScreen(),
              }),
        ),
      ),
    );
  }
}
