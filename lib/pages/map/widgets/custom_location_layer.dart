import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/follow_location_state.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/map/align_flutter_map_provider.dart';
import '../../../providers/map/camera_follow_location_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import '../../../providers/settings/me_color_provider.dart';
import 'location_marker_widget.dart';

class CustomLocationLayer extends ConsumerStatefulWidget {
  const CustomLocationLayer(this.hasGesture, {super.key});

  final bool hasGesture;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomLocationLayer();
}

class _CustomLocationLayer extends ConsumerState<CustomLocationLayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isTracking = ref.watch(isTrackingProvider);
    var cameraFollow = ref.watch(cameraFollowLocationProvider);
    var alignMap = ref.watch(alignFlutterMapProvider);
    var iconSize = ref.watch(iconSizeProvider);
    //var headingStream = ref.watch(rawStreamProvider);

    //print('Widget has gesture ${widget.hasGesture}');
    return !isTracking
        ? Container()
        : CurrentLocationLayer(
            //indicators: const LocationMarkerIndicators(),

            alignDirectionAnimationDuration: const Duration(milliseconds: 300),
            alignPositionOnUpdate: cameraFollow == CameraFollow.followMe &&
                    !widget.hasGesture &&
                    (alignMap ==
                            AlignFlutterMapState.alignPositionOnUpdateOnly ||
                        alignMap ==
                            AlignFlutterMapState
                                .alignDirectionAndPositionOnUpdate)
                ? AlignOnUpdate.always
                : AlignOnUpdate.never,
            alignDirectionOnUpdate: cameraFollow == CameraFollow.followMe &&
                    !widget.hasGesture &&
                    (alignMap ==
                            AlignFlutterMapState.alignDirectionOnUpdateOnly ||
                        alignMap ==
                            AlignFlutterMapState
                                .alignDirectionAndPositionOnUpdate)
                ? AlignOnUpdate.always
                : AlignOnUpdate.never,
            style: LocationMarkerStyle(
              showAccuracyCircle: false,
              showHeadingSector: true,
              headingSectorColor: CupertinoTheme.of(context).primaryColor,
              accuracyCircleColor: ref.watch(meColorProvider),
              marker: DefaultLocationMarker(
                color: CupertinoTheme.of(context).barBackgroundColor,
                child: const UserLocationMarker(),
              ),
              markerSize: Size(
                MediaQuery.textScalerOf(context).scale(iconSize),
                MediaQuery.textScalerOf(context).scale(iconSize),
              ),
              markerDirection: MarkerDirection.heading,
            ),
          );
  }
}
