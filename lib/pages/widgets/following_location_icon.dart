import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../pages/map/map_page.dart';
import '../../providers/location_provider.dart';

class FollowingLocationIcon extends StatelessWidget {
  const FollowingLocationIcon({required this.followLocationStatus, super.key});
  final FollowLocationStates followLocationStatus;
  @override
  Widget build(BuildContext context) {
    var userIsParticipating = context.watch(isUserParticipatingProvider);
    switch (followLocationStatus) {
      case FollowLocationStates.followOff:
        return const Icon(CupertinoIcons.location_circle);
      case FollowLocationStates.followMe:
        return userIsParticipating
            ? const ImageIcon(AssetImage('assets/images/skaterIcon_256.png'))
            : const Icon(Icons.gps_fixed_sharp);
      case FollowLocationStates.followMeStopped:
        return const Icon(
          CupertinoIcons.location_circle_fill,
        );
      case FollowLocationStates.followTrain:
        return const ImageIcon(
          AssetImage('assets/images/skatechildmunichicon_256.png'),
        );
      case FollowLocationStates.followTrainStopped:
        return const Icon(
          CupertinoIcons.location_circle_fill,
        );
    }
  }
}
