// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n.dart';
import 'base_app_scaffold.dart';
import 'navigation_rail.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? ValueKey(navigationShell.currentIndex));
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 650) {
        return ScaffoldWithNavigationRail(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithTabBarNavigation(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}

class ScaffoldWithRailNavigationBar extends StatelessWidget {
  const ScaffoldWithRailNavigationBar({
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
    return BaseAppScaffold(child: body);
  }
}

class ScaffoldWithTabBarNavigation extends StatelessWidget {
  const ScaffoldWithTabBarNavigation({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BaseAppScaffold(
      child: CupertinoTabScaffold(
        key: super.key, //  ValueKey(navigationShell.currentIndex),
        // controller: tabController,
        tabBar: CupertinoTabBar(
          onTap: onDestinationSelected,
          currentIndex: currentIndex,
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          items: [
            /*for (var branch in navigationShell.route.branches)
                              BottomNavigationBarItem(
                                icon: const Icon(CupertinoIcons.home),
                                label: branch.defaultRoute.toString(),
                              ),*/
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.home),
              label: Localize.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.map),
              label: Localize.of(context).map,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.calendar),
              label: Localize.of(context).events,
            ),
            if (!kIsWeb)
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.group),
                label: Localize.of(context).friends,
              ),
            if (!kIsWeb)
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.settings_solid),
                label: Localize.of(context).settings,
              ),
          ],
        ),
        tabBuilder: (context, index) {
          return SafeArea(child: navigationShell);
        },
      ),
    );
  }
}
