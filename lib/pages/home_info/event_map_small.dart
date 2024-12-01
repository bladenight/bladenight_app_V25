import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/location_bearing_distance.dart';
import '../../models/bn_map_marker.dart';
import '../../models/event.dart';
import '../../models/route.dart' hide LatLng;
import '../../providers/map/icon_size_provider.dart';
import '../widgets/event_info/map_layer_overview.dart';

class EventMapSmall extends ConsumerStatefulWidget {
  const EventMapSmall(
      {super.key, this.borderRadius = 15.0, required this.nextEvent});

  final double borderRadius;
  final Event nextEvent;

  @override
  ConsumerState<EventMapSmall> createState() => _EventMapSmallState();
}

class _EventMapSmallState extends ConsumerState<EventMapSmall> {
  @override
  Widget build(BuildContext context) {
    var iconSize = ref.watch(iconSizeProvider);
    /*return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight < 100.0) {
          return Container();
        } else {*/
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadius),
        topRight: Radius.circular(widget.borderRadius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
      child: Builder(
        builder: (context) {
          var sizeValue = MediaQuery.textScalerOf(context).scale(iconSize);
          return Stack(children: [
            MapLayerOverview(
              event: widget.nextEvent,
              showSpeed: false,
              initialZoom:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 10
                      : 11,
              startPoint: widget.nextEvent.nodes.firstOrDefault,
              finishPoint: widget.nextEvent.nodes.lastOrDefault,
              polylines: [
                Polyline(
                  //current and active route points
                  points: widget.nextEvent.nodes,
                  color: CupertinoTheme.of(context).primaryColor,
                  // CupertinoTheme.of(context).primaryColor,
                  strokeWidth: 4,
                ),
              ],
              markers: [
                //finishMarker
                ...[
                  if (widget.nextEvent.nodes.isNotEmpty)
                    BnMapMarker(
                      buildContext: context,
                      headerText: Localize.of(context).finish,
                      color: Color.fromARGB(255, 255, 0, 0),
                      width: 20.0,
                      height: 20.0,
                      point: widget.nextEvent.nodes.last,
                      child: Builder(
                        builder: (context) => const Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/finishMarker.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                ], //StartMarker
                ...[
                  if (widget.nextEvent.nodes.isNotEmpty)
                    BnMapMarker(
                      buildContext: context,
                      headerText: Localize.of(context).start,
                      //anchorPosition: AnchorPos.align(AnchorAlign.top),
                      color: Color.fromRGBO(00, 0, 0, 0),
                      width: sizeValue,
                      height: sizeValue,
                      point: widget.nextEvent.nodes.first,
                      child: Builder(
                        builder: (context) => const Stack(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/start_marker.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.nextEvent.nodes.length > 3) ...[
                    for (var hp in GeoLocationHelper.calculateHeadings(
                        widget.nextEvent.nodes))
                      Marker(
                        point: hp.latLng,
                        width: iconSize * 0.5,
                        height: iconSize * 0.5,
                        child: Builder(
                          builder: (context) => Transform.rotate(
                            angle: hp.bearing,
                            child: const Image(
                              image: AssetImage(
                                'assets/images/arrow_up_mgn_small.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ],
            ),
          ]);
        },
      ),
      /*);
        }
      },*/
    );
  }
}
