import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../providers/active_event_notifier_provider.dart';
import 'bn_dark_container.dart';

class MapTileLayer extends StatefulWidget{
  const MapTileLayer({super.key});

  @override
  State<StatefulWidget> createState() => _MapTileState();
}

class _MapTileState extends State<MapTileLayer> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {//update map colors for static tiles

    CupertinoAdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
      setState(() {
      });
    });});
  }

  @override
  Widget build(BuildContext context) {
    if ( CupertinoTheme.brightnessOf(context) == Brightness.light) {
    return const MapTileLayerWidget();
    }
    return bnDarkModeTilesContainerBuilder(context, const MapTileLayerWidget());
    }

    @override
  void dispose() {
      AdaptiveTheme.of(context).modeChangeNotifier.dispose();
    super.dispose();
  }

}

class MapTileLayerWidget extends ConsumerStatefulWidget {
  const MapTileLayerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapTileLayerState();
}

class _MapTileLayerState extends ConsumerState<MapTileLayerWidget> {

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      minNativeZoom: MapSettings.openStreetMapEnabled
          ? MapSettings.minNativeZoom
          : MapSettings.minNativeZoomDefault,
      maxNativeZoom: MapSettings.openStreetMapEnabled
          ? MapSettings.maxNativeZoom
          : MapSettings.maxNativeZoomDefault,
      minZoom: MapSettings.openStreetMapEnabled
          ? MapSettings.minZoom
          : MapSettings.minZoomDefault,
      maxZoom: MapSettings.openStreetMapEnabled
          ? MapSettings.maxZoom
          : MapSettings.maxZoomDefault,
      urlTemplate: MapSettings.openStreetMapEnabled ||
              ref.watch(activeEventProvider).event.hasSpecialStartPoint
          ? MapSettings.openStreetMapLinkString //use own ts
          : 'assets/maptiles/osday/{z}/{x}/{y}.jpg',
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
      tileProvider: MapSettings.openStreetMapEnabled ||
              ref.watch(activeEventProvider).event.hasSpecialStartPoint
          ? CachedTileProvider()
          : AssetTileProvider(),
      errorImage: const AssetImage(
        'assets/images/skatemunichmaperror.png',
      ),
    );
  }
}
