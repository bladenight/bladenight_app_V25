import 'package:flutter_map/flutter_map.dart';

import 'friend.dart';

class BnMapFriendMarker extends Marker {
  const BnMapFriendMarker({
    required super.width,
    required super.point,
    required child,
    required super.height,
    required this.friend,
  }) : super(child: child);

  final Friend friend; //to update friend information
}
