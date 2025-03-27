import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/enums/tracking_type.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/settings/me_color_provider.dart';

/// Returns a [CircleAvatar] icon related to [TrackingType]
///
class TrackingIconWidget extends ConsumerWidget {
  const TrackingIconWidget({this.innerIconSize, this.radius, super.key});

  final double? innerIconSize;
  final double? radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var trackingType = ref.watch(trackingTypeProvider);
    var isMoving = ref.watch(isMovingProvider);
    return CircleAvatar(
      radius: radius,
      backgroundColor: CupertinoTheme.of(context).primaryColor,
      child: Builder(builder: (context) {
        if (trackingType != TrackingType.noTracking && !isMoving) {
          return Icon(
            size: innerIconSize,
            Icons.pause,
            color: ref.watch(meColorProvider),
          );
        }

        switch (trackingType) {
          case TrackingType.userParticipating:
            return Transform.rotate(
              angle: 90,
              child: ImageIcon(
                size: innerIconSize,
                const AssetImage('assets/images/skater_icon_256_bearer.png'),
                color: ref.watch(meColorProvider),
              ),
            );
          case TrackingType.noTracking:
            return Icon(
              size: innerIconSize,
              Icons.stop,
              color: ref.watch(meColorProvider),
            );
          case TrackingType.userNotParticipating:
            return Icon(
              size: innerIconSize,
              Icons.gps_fixed,
              color: ref.watch(meColorProvider),
            );
          case TrackingType.onlyTracking:
            return Icon(
              size: innerIconSize,
              Icons.navigation_outlined,
              color: ref.watch(meColorProvider),
            );
          default:
            return Icon(
              size: innerIconSize,
              Icons.question_mark,
              color: ref.watch(meColorProvider),
            );
        }
      }),
    );
  }
}
