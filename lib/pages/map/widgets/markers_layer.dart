import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/speed_to_color.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/bn_map_friend_marker.dart';
import '../../../models/bn_map_marker.dart';
import '../../../providers/active_event_notifier_provider.dart';
import '../../../providers/realtime_data_provider.dart';
import 'map_friend_marker_popup.dart';
import 'map_marker_popup.dart';

class MarkersLayer extends ConsumerStatefulWidget {
  const MarkersLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarkersLayerState();
}

class _MarkersLayerState extends ConsumerState<MarkersLayer> {
  final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    var activeEvent = ref.watch(activeEventProvider);
    var realtimeData = ref.watch(realtimeDataProvider);
    var runningRoutePoints =
        realtimeData?.runningRoute(activeEvent.activeEventRoutePoints);
    var headingRoutePoints = activeEvent.headingPoints;
    var sizeValue =
        MediaQuery.textScalerOf(context).scale(HiveSettingsDB.iconSizeValue);
    return PopupMarkerLayer(
      options: PopupMarkerLayerOptions(
        popupDisplayOptions: PopupDisplayOptions(
          builder: (BuildContext context, Marker marker) {
            if (marker is BnMapMarker) {
              return MapMarkerPopup(marker);
            } else if (marker is BnMapFriendMarker) {
              return MapFriendMarkerPopup(marker);
            }
            return Container();
          },
          snap: PopupSnap.markerBottom,
          animation:
              const PopupAnimation.fade(duration: Duration(milliseconds: 200)),
        ),
        markerCenterAnimation: const MarkerCenterAnimation(),
        markers: [
          //begin direction arrows in track
          if (headingRoutePoints.isNotEmpty) ...[
            for (var hp in headingRoutePoints)
              Marker(
                width: 20,
                height: 20,
                point: hp.latLng,
                child: Builder(
                  builder: (context) => Transform.rotate(
                    angle: hp.bearing,
                    child: const Image(
                      image: AssetImage(
                        'assets/images/arrow_up.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
          //end direction arrows in track

          //begin skater tail marker
          if (runningRoutePoints != null && runningRoutePoints.isNotEmpty) ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).tail,
              speedText:
                  '${((ref.read(realtimeDataProvider)?.tail.speed) ?? '-')} km/h',
              drivenDistanceText:
                  '${((ref.read(realtimeDataProvider)?.tail.position) ?? '-')} m',
              timeToHeadText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: ref.read(realtimeDataProvider)?.timeTrainComplete() ?? 0))}',
              distanceToHeadText:
                  '${((ref.read(realtimeDataProvider)?.distanceOfTrainComplete()) ?? '-')} m',
              timeUserToTailText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: ref.read(realtimeDataProvider)?.timeUserToTail() ?? 0))}',
              distanceUserToTailText:
                  '${((ref.read(realtimeDataProvider)?.distanceOfUserToTail()) ?? '-')} m',
              color: Colors.orange,
              point: runningRoutePoints.last,
              width: sizeValue,
              height: sizeValue,
              child: Builder(
                builder: (context) => const Image(
                  image: AssetImage(
                    'assets/images/skatechildmunichred.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          //end skater tail marker

          //begin skater head marker
          if (runningRoutePoints != null && runningRoutePoints.isNotEmpty) ...[
            //Skater head marker -set as 2nd because tail overlay drawn first
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).head,
              speedText:
                  '${((ref.read(realtimeDataProvider)?.head.speed) ?? '-')} km/h',
              drivenDistanceText:
                  '${((ref.read(realtimeDataProvider)?.head.position) ?? '-')} m',
              distanceTailText:
                  '${((ref.read(realtimeDataProvider)?.distanceOfTrainComplete()) ?? '-')} m',
              timeToTailText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: ref.read(realtimeDataProvider)?.timeTrainComplete() ?? 0))}',
              timeUserToHeadText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: ref.read(realtimeDataProvider)?.timeUserToHead() ?? 0))}',
              distanceUserToHeadText:
                  '${((ref.read(realtimeDataProvider)?.distanceOfUserToHead()) ?? '-')} m',
              color: Colors.lightBlue,
              point: runningRoutePoints.first,
              width: sizeValue,
              height: sizeValue,
              child: Builder(
                builder: (context) => const Image(
                  image: AssetImage(
                    'assets/images/skatechildmunich.png',
                  ),
                ),
              ),
            ),
          ],
          //end skater head marker

          //beginn finish marker
          if (runningRoutePoints != null && runningRoutePoints.isNotEmpty) ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).finish,
              color: Colors.red,
              width: 35.0,
              height: 35.0,
              point: activeEvent.activeEventRoutePoints.last,
              child: Builder(
                builder: (context) => const Stack(
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/finishMarker.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ],
          //end finish marker

          //begin start marker
          if (runningRoutePoints != null && runningRoutePoints.isNotEmpty) ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).start,
              //anchorPosition: AnchorPos.align(AnchorAlign.top),
              color: Colors.transparent,
              width: 35.0,
              height: 35.0,
              point: activeEvent.activeEventRoutePoints.first,
              child: Builder(
                builder: (context) => const Stack(
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/startMarker.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ],
          //end start marker

          //begin friends marker
          //Friends are only in [RealTimeData] available when we send an new user position to server.
          //Friend has to stay visible when online - replace on offline message after send location
          //collect friend list to check where online is, leave it in Marker list

          if (realtimeData != null && realtimeData.friends.friends.isNotEmpty)
            for (var friend
                in realtimeData.mapPointFriends(realtimeData.friends))
              BnMapFriendMarker(
                friend: friend,
                point: LatLng(friend.latitude ?? defaultLatitude,
                    friend.longitude ?? defaultLongitude),
                width: friend.specialValue == 99 ? sizeValue - 8 : sizeValue,
                height: friend.specialValue == 99 ? sizeValue - 8 : sizeValue,
                child: Builder(
                  builder: (context) {
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 1) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: SpeedToColor.getColorFromSpeed(
                                friend.realSpeed),
                            shape: BoxShape.circle),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/skatechildmunichgreen.png'),
                        ),
                      );
                    }
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 2) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: SpeedToColor.getColorFromSpeed(
                                friend.realSpeed),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: sizeValue - 6,
                          backgroundImage: const AssetImage(
                              'assets/images/skatechildmunichred.png'),
                        ),
                      );
                    }
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 99) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: sizeValue - 6,
                          backgroundColor:
                              SpeedToColor.getColorFromSpeed(friend.realSpeed)
                                  .withOpacity(0.4),
                          child: Container(),
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: sizeValue,
                      backgroundColor: friend.color,
                      child: Center(child: Text(friend.name.substring(0, 1))),
                    );
                  },
                ),
              ),

          //end friends marker
        ],
        popupController: _popupLayerController,
        markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
        // : MarkerTapBehavior.togglePopupAndHideRest(),
        onPopupEvent: (event, selectedMarkers) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
