import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../providers/active_event_provider.dart';
import '../../../providers/map/use_open_street_map_provider.dart';
import '../tiles_provider.dart';
import 'bn_dark_container.dart';

class MapTileLayer extends StatefulWidget {
  const MapTileLayer({super.key});

  @override
  State<StatefulWidget> createState() => _MapTileState();
}

class _MapTileState extends State<MapTileLayer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //update map colors for static tiles
     /* CupertinoAdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
        setState(() {});
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    if (CupertinoTheme.brightnessOf(context) == Brightness.light) {
      return const MapTileLayerWidget();
    }
    return bnDarkModeTilesContainerBuilder(context, const MapTileLayerWidget());
  }

  @override
  void dispose() {
    BnLog.info(
        text: 'mapTileLayer disposed',
        methodName: 'dispose',
        className: toString());
    /*   context.dependOnInheritedWidgetOfExactType<
        InheritedAdaptiveTheme<CupertinoThemeData>>()!; crashes because null value
    CupertinoAdaptiveTheme.of(context).modeChangeNotifier.removeListener(() {
      setState(() {});
    });*/
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
    var osmEnabled = ref.watch(useOpenStreetMapProvider);
    return TileLayer(
      minNativeZoom: osmEnabled
          ? MapSettings.minNativeZoom
          : MapSettings.minNativeZoomDefault,
      maxNativeZoom: osmEnabled
          ? MapSettings.maxNativeZoom
          : MapSettings.maxNativeZoomDefault,
      minZoom: osmEnabled ? MapSettings.minZoom : MapSettings.minZoomDefault,
      maxZoom: osmEnabled ? MapSettings.maxZoom : MapSettings.maxZoomDefault,
      urlTemplate:
          osmEnabled || ref.watch(activeEventProvider).hasSpecialStartPoint
              ? MapSettings.openStreetMapLinkString //use own ts
              : 'assets/maptiles/osday/{z}/{x}/{y}.jpg',
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
      tileProvider: osmEnabled ||
              ref.watch(activeEventProvider).hasSpecialStartPoint
          ? CachedTileProvider(
              maxStale: const Duration(days: 30),
              store: HiveCacheStore(
                null,
                hiveBoxName: 'HiveCacheStore',
              ),
            )
          : BnCachedAssetProvider(
              context: context,
              errorListener: () {
                print('errlistbntile');
              },
              callBack: (TileImage tile, Object error, StackTrace? stackTrace) {
                print('errbntile');
              }),
      errorImage: const AssetImage(
        'assets/images/skatemunichmaperror.png',
      ),
    );
  }
}
