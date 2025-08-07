import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/location_bearing_distance.dart';
import '../../../providers/active_event_route_provider.dart';
import '../../../providers/map/heading_marker_amount_provider.dart';

class HeadingsLayer extends ConsumerStatefulWidget {
  const HeadingsLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeadingsLayerState();
}

class _HeadingsLayerState extends ConsumerState<HeadingsLayer> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final camera = MapCamera.of(context);
      ref.read(headingMarkerAmountProvider.notifier).setSize(camera.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<HeadingPoint> headingRoutePoints;
    var headingRoutePointsP = ref.watch(headingPointsProvider);
    headingRoutePoints = headingRoutePointsP.value ?? <HeadingPoint>[];
    var headingMarkerSize = ref.watch(headingMarkerAmountProvider);

    return MarkerLayer(
      markers: [
        //begin direction arrows in track
        if (headingRoutePoints.isNotEmpty) ...[
          for (var hp in headingRoutePoints)
            Marker(
              width: headingMarkerSize,
              height: headingMarkerSize,
              point: hp.latLng,
              child: Builder(
                builder: (context) => Transform.rotate(
                  angle: hp.bearing,
                  child: Image(
                    image:
                        CupertinoAdaptiveTheme.of(context).theme.brightness ==
                                Brightness.dark
                            ? AssetImage(
                                'assets/images/arrow_up_pure_margin.png',
                              )
                            : AssetImage(
                                'assets/images/arrow_up_pure_margin_dark.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
        //end direction arrows in track
      ],
    );
  }
}
