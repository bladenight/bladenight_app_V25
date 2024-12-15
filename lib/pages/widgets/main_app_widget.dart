import 'package:adaptive_theme/adaptive_theme.dart';
import 'route_name_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../main.dart';
import '../bladeguard/bladeguard_page.dart';
import '../home_screen.dart';
import '../loading_screen.dart';
import 'intro_slider.dart';

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic obj) async {
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
      child: Builder(
        builder: (builder) => ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: MediaQuery.fromView(
            view: View.of(context),
            child: CupertinoAdaptiveTheme(
              light: CupertinoThemeData(
                  brightness: Brightness.light,
                  primaryColor: HiveSettingsDB.themePrimaryLightColor),
              dark: CupertinoThemeData(
                brightness: Brightness.dark,
                primaryColor: HiveSettingsDB.themePrimaryDarkColor,
              ),
              initial: HiveSettingsDB.adaptiveThemeMode,
              builder: (theme) => CupertinoApp(
                /* onGenerateRoute: (uriString) {
                    BnLog.info(
                        text: 'onGenerateRoute requested ${uriString.name}');
                    if (uriString.name == null) return null;
                    if (uriString.name!.startsWith('/showroute')) {
                      return CupertinoPageRoute(
                          builder: (context) => RouteNameDialog(
                                routeName: uriString.name
                                    .toString()
                                    .replaceAll('/showroute?', '')
                                    .trim(),
                              ),
                          fullscreenDialog: true);
                    }
                    if (uriString.name!.startsWith(openBladeguardOnSite)) {
                      return CupertinoPageRoute(
                          builder: (context) => const BladeGuardPage(),
                          fullscreenDialog: true);
                    }
                    if (uriString.name!.contains('?data=')) {
                      importData(context, uriString.name!);
                    } else if (uriString.name!.contains('?addFriend')) {
                      //tabController.index = 3;
                      addFriendWithCodeFromUrl(context, uriString.name!)
                          .then((value) => null);
                    } else if (uriString.name!.contains('?$specialCode=1')) {
                      HiveSettingsDB.setHasSpecialRightsPrefs(true);
                    } else if (uriString.name!.contains('?$specialCode=0')) {
                      HiveSettingsDB.setHasSpecialRightsPrefs(false);
                    }
                    return null;
                  },*/
                title: 'BladeNight München',
                debugShowCheckedModeBanner: false,
                theme: theme,
                localizationsDelegates: const [
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
                navigatorKey: navigatorKey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
