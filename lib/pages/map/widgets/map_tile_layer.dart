import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import '../../../app_settings/app_constants.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger/logger.dart';
import '../../../providers/active_event_provider.dart';
import '../../../providers/map/use_open_street_map_provider.dart';
import 'bn_dark_container.dart';

///Layer to load and draw map tiles
///
///[hasSpecialStartPoint] to load OpenStreetMap Tiles if [true]
class MapTileLayer extends StatefulWidget {
  const MapTileLayer({super.key, this.hasSpecialStartPoint = false});

  final bool hasSpecialStartPoint;

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
      return MapTileLayerWidget(
          hasSpecialStartPoint: widget.hasSpecialStartPoint);
    }
    return bnDarkModeTilesContainerBuilder(context,
        MapTileLayerWidget(hasSpecialStartPoint: widget.hasSpecialStartPoint));
  }

  @override
  void dispose() {
    BnLog.info(
        text: 'mapTileLayer disposed',
        methodName: 'dispose',
        className: toString());
    super.dispose();
  }
}

class MapTileLayerWidget extends ConsumerStatefulWidget {
  const MapTileLayerWidget({super.key, this.hasSpecialStartPoint = false});

  final bool hasSpecialStartPoint;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapTileLayerState();
}

class _MapTileLayerState extends ConsumerState<MapTileLayerWidget> {
  Uint8List? errorImageBytes;

  @override
  void initState() {
    initErrorImage();
    super.initState();
  }

  void initErrorImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/skateMunichMapError.png');
    errorImageBytes = bytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    var osmEnabled =
        ref.watch(useOpenStreetMapProvider) || widget.hasSpecialStartPoint;
    return TileLayer(
      userAgentPackageName: 'app.skatemunich.bladenight',
      //retinaMode: RetinaMode.isHighDensity(context) ? true : false,
      minNativeZoom: osmEnabled
          ? MapSettings.minNativeZoom
          : MapSettings.minNativeZoomDefault,
      maxNativeZoom: osmEnabled
          ? MapSettings.maxNativeZoom
          : MapSettings.maxNativeZoomDefault,
      minZoom: osmEnabled ? MapSettings.minZoom : MapSettings.minZoomDefault,
      maxZoom: osmEnabled ? MapSettings.maxZoom : MapSettings.maxZoomDefault,
      /*tileBuilder: (context, widget, tile) => Stack(
        fit: StackFit.passthrough,
        children: [
          widget,
          Center(
            child: Text(
                '${tile.coordinates.x.floor()} : ${tile.coordinates.y.floor()} : ${tile.coordinates.z.floor()}'),
          ),
        ],
      ),*/
      urlTemplate:
          osmEnabled || ref.watch(activeEventProvider).hasSpecialStartPoint
              ? MapSettings.openStreetMapLinkString //use own ts
              : MapSettings.bayernAtlasLinkString,
      //'assets/maptiles/osday/{z}/{x}/{y}.jpg',
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
      tileProvider: kIsWeb
          ? CancellableNetworkTileProvider()
          : FMTCTileProvider(
              loadingStrategy: BrowseLoadingStrategy.cacheFirst,
              stores: {fmtcTileStoreName: BrowseStoreStrategy.readUpdateCreate},
              cachedValidDuration: Duration(days: 90),
              errorHandler: (failure) {
                return errorImageBytes;
              },
            ),
      errorImage: const AssetImage(
        'assets/images/skateMunichMapErrorInverted.png',
      ),
    );
  }
}
