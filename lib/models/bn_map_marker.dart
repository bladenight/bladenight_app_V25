import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

class BnMapMarker extends Marker {
  const BnMapMarker(
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
      required this.buildContext,
      required super.height,
      required super.width,
      required super.point,
      required super.child,
      required this.color});

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
  final BuildContext? buildContext;
}
