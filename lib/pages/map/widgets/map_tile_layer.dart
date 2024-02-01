import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../providers/active_event_notifier_provider.dart';
import 'bn_dark_container.dart';

class MapTileLayer extends StatelessWidget {
  const MapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    if (CupertinoTheme.brightnessOf(context) == Brightness.light) {
      return const MapTileLayerWidget();
    }

    return bnDarkModeTilesContainerBuilder(context, const MapTileLayerWidget());
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
      minNativeZoom: HiveSettingsDB.openStreetMapEnabled
          ? MapSettings.minNativeZoom
          : MapSettings.minNativeZoomDefault,
      maxNativeZoom: HiveSettingsDB.openStreetMapEnabled
          ? MapSettings.maxNativeZoom
          : MapSettings.maxNativeZoomDefault,
      minZoom: HiveSettingsDB.openStreetMapEnabled
          ? MapSettings.minZoom
          : MapSettings.minZoomDefault,
      maxZoom: HiveSettingsDB.openStreetMapEnabled
          ? MapSettings.maxZoom
          : MapSettings.maxZoomDefault,
      urlTemplate: HiveSettingsDB.openStreetMapEnabled ||
              ref.watch(activeEventProvider).event.hasSpecialStartPoint
          ? MapSettings.openStreetMapLinkString //use own ts
          : 'assets/maptiles/osday/{z}/{x}/{y}.jpg',
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
      tileProvider: HiveSettingsDB.openStreetMapEnabled ||
              ref.watch(activeEventProvider).event.hasSpecialStartPoint
          ? CancellableNetworkTileProvider()
          : AssetTileProvider(),
      errorImage: const AssetImage(
        'assets/images/skatemunichmaperror.png',
      ),
    );
  }
}
