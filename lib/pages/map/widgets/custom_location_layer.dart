import 'package:flutter/cupertino.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/follow_location_state.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/align_flutter_map_provider.dart';
import '../../../providers/map/camera_follow_location_provider.dart';
import '../../../providers/map/compass_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import '../../../providers/settings/me_color_provider.dart';
import 'location_marker_widget.dart';

class CustomLocationLayer extends ConsumerStatefulWidget {
  const CustomLocationLayer(this.popupController, this.hasGesture, {super.key});

  final PopupController popupController;
  final bool hasGesture;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomLocationLayer();
}

class _CustomLocationLayer extends ConsumerState<CustomLocationLayer> {
  late final Stream<LocationMarkerPosition?> _positionStream;
  late final Stream<LocationMarkerHeading?> _headingStream;
  ProviderSubscription<AsyncValue<LatLng?>>? locationSubscription;

  @override
  void initState() {
    super.initState();
    _positionStream =
        LocationProvider.instance.userLocationMarkerPositionStream;
    _headingStream = LocationProvider.instance.userLocationMarkerHeadingStream;
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
            positionStream: _positionStream,
            //indicators: const LocationMarkerIndicators(),
            headingStream: _headingStream,
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
              headingSectorColor: ref.watch(meColorProvider),
              accuracyCircleColor: CupertinoTheme.of(context).primaryColor,
              marker: DefaultLocationMarker(
                color: CupertinoTheme.of(context).barBackgroundColor,
                child: const UserLocationMarker(),

                /*
                var locationUpdate = ref.watch(locationProvider);

                child: PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        if (marker is BnMapMarker) {
                          return MapMarkerPopup(marker);
                        }
                        return Container();
                      },
                      snap: PopupSnap.markerBottom,
                    ),
                    markerCenterAnimation: const MarkerCenterAnimation(),
                    markers: [
                      BnMapMarker(
                        buildContext: context,
                        headerText: '${Localize.of(context).me} '
                            '${locationUpdate.isHead ? "${Localize.of(context).iam} ${Localize.of(context).head}" : ''} '
                            '${locationUpdate.isTail ? "${Localize.of(context).iam} ${Localize.of(context).tail}" : ''} ',
                        speedText:
                            '${locationUpdate.realUserSpeedKmh == null ? '- km/h' : locationUpdate.realUserSpeedKmh.formatSpeedKmH()} ∑${locationUpdate.odometer.toStringAsFixed(1)} km',
                        drivenDistanceText:
                            '${((locationUpdate.realtimeUpdate?.user.position) ?? '-')} m',
                        timeUserToHeadText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToHead() ?? 0))}',
                        distanceUserToHeadText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToHead()) ?? '-')} m',
                        timeUserToTailText:
                            '${(TimeConverter.millisecondsToDateTimeString(value: locationUpdate.realtimeUpdate?.timeUserToTail() ?? 0))}',
                        distanceUserToTailText:
                            '${((locationUpdate.realtimeUpdate?.distanceOfUserToTail()) ?? '-')} m',
                        color: ref.watch(MeColor.provider),
                        point: locationUpdate.userLatLng!,
                        width: iconSize,
                        height: iconSize,
                        child: Builder(builder: (context) {
                          if (locationUpdate.isHead) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: iconSize - 5,
                                backgroundImage: const AssetImage(
                                    'assets/images/skater_icon_256.png'),
                                backgroundColor: ref
                                    .watch(MeColor.provider)
                                    .withOpacity(0.6),
                              ),
                            );
                          } else if (locationUpdate.isTail) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.purple, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: iconSize - 5,
                                backgroundImage: const AssetImage(
                                    'assets/images/skater_icon_256.png'),
                                backgroundColor: ref
                                    .watch(MeColor.provider)
                                    .withOpacity(0.6),
                              ),
                            );
                          }
                          return CircleAvatar(
                            backgroundColor:
                                ref.watch(MeColor.provider).withOpacity(0.6),
                            child: locationUpdate.userIsParticipant
                                ? const ImageIcon(AssetImage(
                                    'assets/images/skater_icon_256.png'))
                                : const Icon(Icons.gps_fixed_sharp),
                          );
                        }),
                      ),
                    ],
                    popupController: widget.popupController,
                    markerTapBehavior:
                        MarkerTapBehavior.togglePopupAndHideRest(),
                    // : MarkerTapBehavior.togglePopupAndHideRest(),
                    onPopupEvent: (event, selectedMarkers) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),*/
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
