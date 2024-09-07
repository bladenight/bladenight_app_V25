import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/follow_location_state.dart';
import '../../providers/location_provider.dart';

class FollowingLocationIcon extends ConsumerWidget {
  const FollowingLocationIcon({required this.followLocationStatus, super.key});

  final CameraFollow followLocationStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userIsParticipating = ref.watch(isUserParticipatingProvider);
    switch (followLocationStatus) {
      case CameraFollow.followOff:
        return const Icon(CupertinoIcons.location_circle);
      case CameraFollow.followMe:
        return userIsParticipating
            ? const ImageIcon(AssetImage('assets/images/skater_icon_256.png'))
            : const Icon(Icons.gps_fixed_sharp);
      case CameraFollow.followMeStopped:
        return const Icon(
          CupertinoIcons.location_circle_fill,
        );
      case CameraFollow.followTrain:
        return const ImageIcon(
          AssetImage('assets/images/skatechildmunichicon_256.png'),
        );
      case CameraFollow.followTrainStopped:
        return const Icon(
          CupertinoIcons.location_circle_fill,
        );
    }
  }
}
