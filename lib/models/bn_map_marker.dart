import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BnMapMarker extends Marker {
  BnMapMarker(
      {required this.headerText,
      this.speedText,
      this.drivenDistanceText,
      this.distanceToHeadText,
      this.timeToHeadText,
      this.distanceUserToHeadText,
      this.timeUserToHeadText,
      this.distanceUserToTailText,
      this.timeUserToTailText,
      this.distanceTailText,
      this.timeToTailText,
      this.rightWidget,
      this.anchorPosition,
      required this.buildContext,
      required height,
      required width,
      required LatLng point,
      required WidgetBuilder builder,
      required this.color})
      : super(
            point: point,
            builder: builder,
            anchorPos: anchorPosition,
            width: width,
            height: height);

  final Color color;
  final String headerText;
  final String? speedText;
  final String? drivenDistanceText;
  final String? distanceToHeadText;
  final String? timeToHeadText;
  final String? distanceUserToHeadText;
  final String? timeUserToHeadText;
  final String? distanceUserToTailText;
  final String? timeUserToTailText;
  final String? distanceTailText;
  final String? timeToTailText;
  final Widget? rightWidget;
  final AnchorPos? anchorPosition;
  final BuildContext? buildContext;
}
