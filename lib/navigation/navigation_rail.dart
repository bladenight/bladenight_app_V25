import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n.dart';
import 'base_app_scaffold.dart';

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
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
      child: Row(
        children: [
          // Fixed navigation rail on the left (start)
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                label: Text(
                  Localize.of(context).home,
                ),
                icon: Icon(Icons.home),
              ),
              NavigationRailDestination(
                label: Text(
                  Localize.of(context).map,
                ),
                icon: Icon(Icons.map),
              ),
              NavigationRailDestination(
                label: Text(
                  Localize.of(context).events,
                ),
                icon: Icon(Icons.event_available_rounded),
              ),
              if (!kIsWeb)
                NavigationRailDestination(
                  label: Text(
                    Localize.of(context).friends,
                  ),
                  icon: Icon(Icons.people_alt_rounded),
                ),
              NavigationRailDestination(
                label: Text(
                  Localize.of(context).settings,
                ),
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content on the right (end)
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }
}
