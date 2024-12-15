// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../main.dart';
import '../../pages/bladeguard/bladeguard_page.dart';
import '../../pages/events/events_page.dart';
import '../../pages/friends/friends_page.dart';
import '../../pages/home_page.dart';
import '../../pages/map/map_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/widgets/route_name_dialog.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    //add localize and delegates

    final size = MediaQuery.sizeOf(context);
    if (size.width < 450) {
      return ScaffoldWithTabBarNavigation(
        //ScaffoldWithNavigationBar(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return ScaffoldWithTabBarNavigation(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

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
                onGenerateRoute: (uriString) {
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
                home: body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScaffoldWithTabBarNavigation extends StatelessWidget {
  const ScaffoldWithTabBarNavigation({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

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
                      title: 'BladeNight München',
                      debugShowCheckedModeBanner: false,
                      theme: theme,
                      home: CupertinoTabScaffold(
                        // controller: tabController,
                        tabBar: CupertinoTabBar(
                          onTap: onDestinationSelected,
                          currentIndex: currentIndex,
                          backgroundColor: CupertinoTheme.of(context)
                              .barBackgroundColor
                              .withOpacity(1.0),
                          items: [
                            BottomNavigationBarItem(
                              icon: const Icon(CupertinoIcons.home),
                              label: Localize.of(context).home,
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(CupertinoIcons.map),
                              label: Localize.of(context).map,
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(CupertinoIcons.ticket),
                              label: Localize.of(context).events,
                            ),
                            if (!kIsWeb)
                              BottomNavigationBarItem(
                                icon: const Icon(CupertinoIcons.group),
                                label: Localize.of(context).friends,
                              ),
                            BottomNavigationBarItem(
                              icon: const Icon(CupertinoIcons.settings_solid),
                              label: Localize.of(context).settings,
                            ),
                          ],
                        ),
                        tabBuilder: (context, index) {
                          return body;
                          switch (index) {
                            case 0:
                              return HomePage();
                            case 1:
                              return const MapPage();
                            case 2:
                              return const EventsPage();
                            case 3:
                              if (!kIsWeb) {
                                return const FriendsPage();
                              }
                              return const SettingsPage();
                            case 4:
                              if (!kIsWeb) {
                                return const SettingsPage();
                              }
                              return Container();
                            /*var ssp = ref.watch(BladeguardLinkImageAndLink.provider);
              return ssp.link == null ? Container() : BladeGuardPage();*/
                            default:
                              return Container();
                          }
                        },
                      ),
                    )),
          ),
        ),
      ),
    );

    /* ],
      ),
    );*/
  }
}
