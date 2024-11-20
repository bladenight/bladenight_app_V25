import 'dart:core';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../models/route.dart';
import '../../../providers/map/heading_marker_size_provider.dart';
import '../../../providers/map_button_visibility_provider.dart';
import '../../widgets/positioned_visibility_opacity.dart';

///Overlay for [flutter_map] to show zoom and light/dark button
///
/// - [bottomMargin] set margin to the bottom
/// - [showHelp] avoid or show ? symbol to avoid displaying a wrong overlay
class MapButtonsLayerLight extends ConsumerStatefulWidget {
  const MapButtonsLayerLight(
      {super.key, this.bottomMargin = 40, this.showHelp = true});

  final double bottomMargin;
  final bool showHelp;

  @override
  ConsumerState<MapButtonsLayerLight> createState() =>
      _MapButtonsLayerLightOverlay();
}

class _MapButtonsLayerLightOverlay extends ConsumerState<MapButtonsLayerLight>
    with SingleTickerProviderStateMixin {
  var animationDuration = const Duration(milliseconds: 800);
  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    animation = CurveTween(curve: Curves.easeIn).animate(animationController!);
    super.initState();
  }

  @override
  void dispose() {
    animationController = null;
    animation = null;
    locationSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.passthrough, children: [
      //#######################################################################
      //Left side buttons
      //#######################################################################
      PositionedVisibilityOpacity(
        left: 10,
        bottom: widget.bottomMargin + 150,
        height: 40,
        heroTag: 'zoomOutTag',
        onPressed: () {
          final controller = MapController.maybeOf(context);
          final camera = MapCamera.maybeOf(context);
          if (controller == null || camera == null) {
            return;
          }
          controller.move(controller.camera.center, camera.zoom - 0.5);
          ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
        },
        visibility: ref.watch(mapMenuVisibleProvider),
        child: Icon(
          CupertinoIcons.zoom_out,
          semanticLabel: MapController.of(context).camera.zoom.toString(),
        ),
      ),
      PositionedVisibilityOpacity(
        heroTag: 'zoomInTag',
        left: 10,
        bottom: widget.bottomMargin + 100,
        height: 40,
        visibility: ref.watch(mapMenuVisibleProvider),
        onPressed: () {
          final controller = MapController.of(context);
          final camera = MapCamera.of(context);
          controller.move(controller.camera.center, camera.zoom + 0.5);
          ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
        },
        child: Icon(
          CupertinoIcons.zoom_in,
          semanticLabel: MapController.of(context).camera.zoom.toString(),
        ),
      ),
      PositionedVisibilityOpacity(
        left: 10,
        bottom: widget.bottomMargin + 50,
        height: 40,
        visibility: ref.watch(mapMenuVisibleProvider),
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
      ),
      Positioned(
        left: 10,
        bottom: widget.bottomMargin,
        height: 40,
        child: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                MapSettings.setMapMenuVisible(!MapSettings.mapMenuVisible);
              });
            },
            tooltip: 'Menu',
            heroTag: 'showMenuTag',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ref.watch(mapMenuVisibleProvider)
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
      if (widget.showHelp)
        Positioned(
          top: kIsWeb ? 10 : 10,
          right: kIsWeb ? 10 : 10,
          height: 30,
          child: Builder(builder: (context) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    MapSettings.setMapMenuVisible(true);
                  });
                  _showOverlay(context, text: '');
                },
                child: const AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Icon(
                      Icons.help,
                    )));
          }),
        ),
    ]);
  }

  void _showOverlay(BuildContext context, {required String text}) async {
    var bottomOffset = kIsWeb ? kBottomNavigationBarHeight : 0.0;

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 00,
              top: kToolbarHeight,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 140.0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CupertinoTheme.of(context).primaryColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                  Text(
                    Localize.of(context).actualInformations,
                    style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 70,
              bottom: 190 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Zoom -',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: 140 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    child: Text(
                      'Zoom +',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: 90 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    child: Text(
                      Localize.of(context).setDarkMode,
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: 40 + bottomOffset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: FadeTransition(
                  opacity: animation!,
                  child: Container(
                    alignment: Alignment.center,
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                        backgroundColor:
                            CupertinoTheme.of(context).barBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
    animationController!.addListener(() {
      overlayState.setState(() {});
    });
    // inserting overlay entry
    overlayState.insert(overlayEntry);
    animationController!.forward();
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
            animationController!
                .reverse()
                .whenCompleteOrCancel(() => overlayEntry.remove())
        // removing overlay entry after stipulated time.
        );
  }
}
