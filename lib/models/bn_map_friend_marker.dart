import 'package:flutter_map/flutter_map.dart';

import 'friend.dart';

class BnMapFriendMarker extends Marker {
  BnMapFriendMarker({
    required width,
    required point,
    required builder,
    required height,
    required this.friend,
  }) : super(width: width, point: point, builder: builder, height: height);

  final Friend friend; //to update friend informations

}
