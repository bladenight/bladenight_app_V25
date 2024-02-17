import 'dart:core';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../providers/map_button_visibility_provider.dart';

class MapLeftButtonsLayer extends ConsumerStatefulWidget {
  const MapLeftButtonsLayer({super.key});

  @override
  ConsumerState<MapLeftButtonsLayer> createState() => _MapLeftButtonsOverlay();
}

class _MapLeftButtonsOverlay extends ConsumerState<MapLeftButtonsLayer>
    with SingleTickerProviderStateMixin {
  var animationDuration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomLeft, children: [
      AnimatedPositioned(
        left: ref.watch(mapSettingsProviderProvider) ? 10 : -100,
        bottom: 190,
        height: 40,
        duration: animationDuration,
        child: FloatingActionButton(
          onPressed: () {
            final controller = MapController.maybeOf(context);
            final camera = MapCamera.maybeOf(context);
            if (controller == null || camera == null) {
              return;
            }
            controller.move(controller.camera.center, camera.zoom - 0.5);
          },
          heroTag: 'zoomInTag',
          child: const Icon(CupertinoIcons.zoom_out),
        ),
      ),
      AnimatedPositioned(
        left: ref.watch(mapSettingsProviderProvider) ? 10 : -100,
        duration: animationDuration,
        bottom: 140,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final controller = MapController.maybeOf(context);
              final camera = MapCamera.maybeOf(context);
              if (controller == null || camera == null) {
                return;
              }
              controller.move(controller.camera.center, camera.zoom + 0.5);
            },
            heroTag: 'zoomOutTag',
            child: const Icon(CupertinoIcons.zoom_in),
          );
        }),
      ),
      AnimatedPositioned(
        duration: animationDuration,
        left: ref.watch(mapSettingsProviderProvider) ? 10 : -100,
        bottom: 90,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              var theme = CupertinoAdaptiveTheme.of(context).theme;
              if (theme.brightness == Brightness.light) {
                CupertinoAdaptiveTheme.of(context).setDark();
                HiveSettingsDB.setAdaptiveThemeMode(AdaptiveThemeMode.dark);
              } else {
                CupertinoAdaptiveTheme.of(context).setLight();
                HiveSettingsDB.setAdaptiveThemeMode(AdaptiveThemeMode.light);
              }
            },
            heroTag: 'darkLightTag',
            child: CupertinoAdaptiveTheme.of(context).theme.brightness ==
                    Brightness.light
                ? const Icon(CupertinoIcons.moon)
                : const Icon(CupertinoIcons.sun_min),
          );
        }),
      ),
      Positioned(
        left: 10,
        bottom: 40,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                MapSettings.setMapMenuVisible(!MapSettings.mapMenuVisible);
              });
            },
            heroTag: 'showMenuTag',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ref.watch(mapSettingsProviderProvider)
                  ? const Icon(
                      Icons.menu_open,
                      key: ValueKey<int>(1),
                    )
                  : const Icon(
                      Icons.menu,
                      key: ValueKey<int>(2),
                    ),
            ),
          );
        }),
      ),
    ]);
  }
}
