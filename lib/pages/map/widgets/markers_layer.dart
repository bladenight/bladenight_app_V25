import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/speed_to_color.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/bn_map_friend_marker.dart';
import '../../../models/bn_map_marker.dart';
import '../../../models/route.dart';
import '../../../models/special_point.dart';
import '../../../providers/active_event_route_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/heading_marker_size_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import 'map_friend_marker_popup.dart';
import 'map_marker_popup.dart';

class MarkersLayer extends ConsumerStatefulWidget {
  const MarkersLayer(this.popupController, {super.key});

  final PopupController popupController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarkersLayerState();
}

class _MarkersLayerState extends ConsumerState<MarkersLayer> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final camera = MapCamera.of(context);
      ref.read(headingMarkerSizeProvider.notifier).setSize(camera.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var activeEventRoutePoints = RoutePoints('', <LatLng>[]);
    var activeEventRouteP = ref.watch(activeEventRouteProvider);
    activeEventRouteP.hasValue
        ? activeEventRoutePoints = activeEventRouteP.value!
        : activeEventRoutePoints = RoutePoints('', <LatLng>[]);

    var processionRoutePointsP = ref.watch(processionRoutePointsProvider);
    var processionRoutePoints = <LatLng>[];
    processionRoutePointsP.hasValue
        ? processionRoutePoints = processionRoutePointsP.value!
        : processionRoutePoints = <LatLng>[];
    var sizeValue = ref.watch(iconSizeProvider);
    var realtimeData = ref.watch(realtimeDataProvider);
    var specialPointsP = ref.watch(specialPointsProvider);
    List<SpecialPoint> specialPoints = specialPointsP.value ?? <SpecialPoint>[];
    var iconSize = ref.watch(iconSizeProvider);

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
          if (specialPoints.isNotEmpty) ...[
            for (var sp in specialPoints)
              BnMapMarker(
                buildContext: context,
                headerText: sp.description,
                color: Colors.lightBlue,
                point: sp.latLon,
                width: iconSize * 0.9,
                height: iconSize * 0.9,
                child: Builder(
                  builder: (context) => CachedNetworkImage(
                    imageUrl: sp.imageUrl,
                    placeholder: (context, url) => Image.asset(
                      specialPointImagePlaceHolder,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      specialPointImagePlaceHolder,
                    ),
                  ),
                ),
              ),
          ],
          //begin finish marker
          ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).finish,
              color: Colors.red,
              width: 35.0,
              height: 35.0,
              point: activeEventRoutePoints.finishLatLngOrDefault,
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
          ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).start,
              //anchorPosition: AnchorPos.align(AnchorAlign.top),
              color: Colors.transparent,
              width: 35.0,
              height: 35.0,
              point: activeEventRoutePoints.startLatLngOrDefault,
              child: Builder(
                builder: (context) => const Stack(
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/start_marker.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ],
          //end start marker

          //begin skater tail marker
          if (processionRoutePoints.isNotEmpty) ...[
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).tail,
              speedText:
                  '${((realtimeData?.tail.realSpeed) == null ? '-' : (realtimeData?.tail.realSpeed)!.toStringAsFixed(1))} km/h',
              drivenDistanceText: '${((realtimeData?.tail.position) ?? '-')} m',
              timeToHeadText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: realtimeData?.timeTrainComplete() ?? 0))}',
              distanceToHeadText:
                  '${((realtimeData?.distanceOfTrainComplete()) ?? '-')} m',
              timeUserToTailText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: realtimeData?.timeUserToTail() ?? 0))}',
              distanceUserToTailText:
                  '${((realtimeData?.distanceOfUserToTail()) ?? '-')} m',
              color: Colors.orange,
              point: processionRoutePoints.last,
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
          if (processionRoutePoints.isNotEmpty) ...[
            //Skater head marker -set as 2nd because tail overlay drawn first
            BnMapMarker(
              buildContext: context,
              headerText: Localize.of(context).head,
              speedText:
                  '${((realtimeData?.head.realSpeed) == null ? '-' : (realtimeData?.head.realSpeed)!.toStringAsFixed(1))} km/h',
              drivenDistanceText: '${((realtimeData?.head.position) ?? '-')} m',
              distanceTailText:
                  '${((realtimeData?.distanceOfTrainComplete()) ?? '-')} m',
              timeToTailText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: realtimeData?.timeTrainComplete() ?? 0))}',
              timeUserToHeadText:
                  '${(TimeConverter.millisecondsToDateTimeString(value: realtimeData?.timeUserToHead() ?? 0))}',
              distanceUserToHeadText:
                  '${((realtimeData?.distanceOfUserToHead()) ?? '-')} m',
              color: Colors.lightBlue,
              point: processionRoutePoints.first,
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
                width: friend.specialValue >= 98 || friend.specialValue == 4
                    ? sizeValue - 6
                    : sizeValue,
                // cursorSize
                height: friend.specialValue >= 98 || friend.specialValue == 4
                    ? sizeValue - 6
                    : sizeValue,
                // cursorSize
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
                        child: CircleAvatar(
                          radius: sizeValue - 6,
                          child: Image.asset(
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
                          child: Image.asset(
                              'assets/images/skatechildmunichred.png'),
                        ),
                      );
                    }
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 4) {
                      //Bladeguard
                      return Container(
                        width: sizeValue - 6,
                        height: sizeValue - 6,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: SpeedToColor.getColorFromSpeed(
                                friend.realSpeed),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: sizeValue,
                          child: Center(
                            child: Icon(
                                size: sizeValue - 10,
                                Icons.remove_red_eye_outlined,
                                color: Colors.redAccent),
                          ),
                        ),
                      );
                    }
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 98) {
                      //Bladeguard
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: SpeedToColor.getColorFromSpeed(
                                friend.realSpeed),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(
                                size: sizeValue - 10,
                                Icons.accessibility_sharp,
                                color: Colors.blueAccent),
                          ),
                        ),
                      );
                    }
                    if (HiveSettingsDB.wantSeeFullOfProcession &&
                        friend.specialValue == 99) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: sizeValue - 5,
                          backgroundColor:
                              SpeedToColor.getColorFromSpeed(friend.realSpeed),
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
        popupController: widget.popupController,
        markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
        // : MarkerTapBehavior.togglePopupAndHideRest(),
        onPopupEvent: (event, selectedMarkers) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
