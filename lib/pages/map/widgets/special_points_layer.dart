import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../models/bn_map_marker.dart';
import '../../../models/special_point.dart';
import '../../../providers/active_event_route_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import 'map_marker_popup.dart';

class SpecialPointsLayer extends ConsumerStatefulWidget {
  const SpecialPointsLayer(this.popupController, {super.key});

  final PopupController popupController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialPointsLayerState();
}

class _SpecialPointsLayerState extends ConsumerState<SpecialPointsLayer> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SpecialPoint> specialPoints;
    var specialPointsP = ref.watch(specialPointsProvider);
    specialPoints = specialPointsP.value ?? <SpecialPoint>[];
    var iconSize = ref.watch(iconSizeProvider);

    return PopupMarkerLayer(
      options: PopupMarkerLayerOptions(
        popupDisplayOptions: PopupDisplayOptions(
          builder: (BuildContext context, Marker marker) {
            if (marker is BnMapMarker) {
              return MapMarkerPopup(marker);
            }
            return Container();
          },
          snap: PopupSnap.markerBottom,
          animation:
              const PopupAnimation.fade(duration: Duration(milliseconds: 200)),
        ),
        markerCenterAnimation: const MarkerCenterAnimation(),

        markers: [
          if (specialPoints.isNotEmpty) ...[
            for (var sp in specialPoints)
              BnMapMarker(
                buildContext: context,
                headerText: sp.description,
                color: Colors.lightBlue,
                point: sp.latLon,
                width: iconSize * 0.9,
                height: iconSize * 0.9,
                child: Builder(
                  builder: (context) => CachedNetworkImage(
                    imageUrl: sp.imageUrl,
                    placeholder: (context, url) => Image.asset(
                      specialPointImagePlaceHolder,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      specialPointImagePlaceHolder,
                    ),
                  ),
                ),
              ),
          ],
        ],
        popupController: widget.popupController,
        markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
        // : MarkerTapBehavior.togglePopupAndHideRest(),
        onPopupEvent: (event, selectedMarkers) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
