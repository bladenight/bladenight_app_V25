import 'package:flutter_map/flutter_map.dart';

import 'friend.dart';

class BnMapFriendMarker extends Marker {
  BnMapFriendMarker({
    required width,
    required point,
    required child,
    required height,
    required this.friend,
  }) : super(width: width, point: point, child: child, height: height);

  final Friend friend; //to update friend informations

}
