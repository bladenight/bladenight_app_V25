import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/route.dart';
import '../../../providers/active_event_provider.dart';
import '../../../providers/friends_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/map_settings_provider.dart';
import '../../../providers/special_procession_function_provider.dart';
import '../../widgets/data_widget_left_right.dart';
import '../../widgets/grip_bar.dart';
import '../../widgets/no_data_warning.dart';
import 'speed_info_colors.dart';
import 'update_progress.dart';

class MapEventInformation extends ConsumerWidget {
  const MapEventInformation({super.key, required this.mapController});

  final MapController mapController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rtu = ref.watch(realtimeDataProvider);
    if (rtu == null) {
      return NoDataWarning(onReload: () {});
    }
    var friends = ref.watch(friendsProvider.select(
        (fr) => fr.where((element) => element.isOnline && element.isActive)));
    var event = ref.watch(activeEventProvider);
    return CupertinoScrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            const GripBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: Text(
                      '${Localize.of(context).bladenight} - ${Localize.of(context).actualInformations}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      color: CupertinoDynamicColor.resolve(
                          CupertinoColors.systemGroupedBackground, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DataLeftRightContent(
                            descriptionLeft: Localize.of(context).lastupdate,
                            descriptionRight: DateFormatter(Localize.current)
                                .getFullDateTimeString(rtu.timeStamp),
                            rightWidget: const UpdateProgress(),
                          ),
                          DataLeftRightContent(
                              descriptionLeft: Localize.of(context).route,
                              descriptionRight: rtu.routeName,
                              rightWidget: Container()),
                          DataLeftRightContent(
                              descriptionLeft: Localize.of(context).length,
                              descriptionRight:
                                  '${((rtu.runningLength) / 1000).toStringAsFixed(1)} km',
                              rightWidget: Container()),
                          DataLeftRightContent(
                              descriptionLeft: Localize.of(context).trackers,
                              descriptionRight: rtu.usersTracking.toString(),
                              rightWidget: Container()),
                          DataLeftRightContent(
                              descriptionLeft: Localize.of(context).startTime,
                              descriptionRight:
                                  DateFormatter(Localize.of(context))
                                      .getLocalDayDateTimeRepresentation(
                                          event.getUtcIso8601DateTime),
                              rightWidget: Container()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: Text(Localize.of(context).train,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    child: Container(
                      color: CupertinoDynamicColor.resolve(
                          CupertinoColors.systemGroupedBackground, context),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DataLeftRightContent(
                              descriptionLeft: Localize.of(context).waittime,
                              descriptionRight:
                                  '⏱Σ ${TimeConverter.millisecondsToDateTimeString(value: rtu.timeTrainComplete(), maxvalue: 120 * 60 * 1000)}',
                              rightWidget: const SizedBox(
                                width: 20,
                              ),
                            ),
                            DataLeftRightContent(
                                descriptionLeft:
                                    Localize.of(context).trainlength,
                                descriptionRight:
                                    '📏 ${(rtu.distanceOfTrainComplete() / 1000).toStringAsFixed(1)} km',
                                rightWidget: Container()),
                            DataLeftRightContent(
                              descriptionLeft:
                                  '${Localize.of(context).distanceDriven} ${Localize.of(context).head}',
                              descriptionRight:
                                  '📏 ${(rtu.head.position / 1000).toStringAsFixed(1)} km',
                              rightWidget: (rtu.head.latitude != null &&
                                      rtu.head.longitude != 0.00)
                                  ? GestureDetector(
                                      onTap: () {
                                        mapController.move(
                                            LatLng(
                                                rtu.head.latitude ??
                                                    defaultLatitude,
                                                rtu.head.longitude ??
                                                    defaultLongitude),
                                            15);
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.gps_fixed_sharp,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor,
                                          size: 20),
                                    )
                                  : Container(),
                            ),
                            DataLeftRightContent(
                                descriptionLeft:
                                    '${Localize.of(context).speed} ${Localize.of(context).head}',
                                descriptionRight: ref
                                        .watch(wantSeeFullProcessionProvider)
                                    ? '📟 ${(rtu.head.realSpeed ?? rtu.head.speed).toStringAsFixed(1)}/ 🖥️ ${(rtu.head.speed).toStringAsFixed(1)} km/h'
                                    : '📟 ${(rtu.head.realSpeed ?? rtu.head.speed).toStringAsFixed(1)} km/h',
                                rightWidget: Container()),
                            DataLeftRightContent(
                              descriptionLeft:
                                  '${Localize.of(context).distanceDriven} ${Localize.of(context).tail}',
                              descriptionRight:
                                  '📏 ${(rtu.tail.position / 1000).toStringAsFixed(1)} km',
                              rightWidget: (rtu.tail.latitude != null &&
                                      rtu.tail.longitude != 0.00)
                                  ? GestureDetector(
                                      onTap: () {
                                        mapController.move(
                                            LatLng(
                                                rtu.tail.latitude ??
                                                    defaultLatitude,
                                                rtu.tail.longitude ??
                                                    defaultLongitude),
                                            15);
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.gps_fixed_sharp,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor,
                                          size: 20),
                                    )
                                  : Container(),
                            ),
                            DataLeftRightContent(
                                descriptionLeft:
                                    '${Localize.of(context).speed} ${Localize.of(context).tail}',
                                descriptionRight: ref
                                        .watch(wantSeeFullProcessionProvider)
                                    ? '📟 ${(rtu.tail.realSpeed ?? rtu.tail.speed).toStringAsFixed(1)}/ 🖥️ ${(rtu.tail.speed).toStringAsFixed(1)} km/h'
                                    : '📟 ${(rtu.tail.realSpeed ?? rtu.tail.speed).toStringAsFixed(1)} km/h',
                                rightWidget: Container()),
                          ]),
                    ),
                  ),
                  if (ref.watch(isTrackingProvider)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(Localize.of(context).me,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      color: CupertinoDynamicColor.resolve(
                          CupertinoColors.systemGroupedBackground, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DataLeftRightContent(
                            descriptionLeft:
                                '${Localize.of(context).own} ${Localize.of(context).distanceDriven}',
                            descriptionRight:
                                '${((rtu.user.position) / rtu.runningLength * 100).toStringAsFixed(1)}% | ↦${((rtu.user.position) / 1000).toStringAsFixed(1)} km',
                            rightWidget: Container(),
                          ),
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).distanceToFinish,
                            descriptionRight:
                                '⇥ ${((rtu.runningLength - rtu.user.position) / 1000).toStringAsFixed(1)} km',
                            rightWidget: GestureDetector(
                              onTap: () {
                                /* mapController.move(
                                        LatLng(ref.watch(userLatLongProvider).
                                            location.userLatLng?.latitude ??
                                                defaultLatitude,
                                            location.userLatLng?.longitude ??
                                                defaultLongitude),
                                        15);*/
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.gps_fixed_sharp,
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                  size: 20),
                            ),
                          ),
                          DataLeftRightContent(
                              descriptionLeft: Localize.of(context).speed,
                              descriptionRight:
                                  '${(rtu.user.realSpeed != null ? rtu.user.realSpeed!.toStringAsFixed(1) : rtu.user.speed)} km/h',
                              rightWidget: Container()),
                          if (!rtu.user.isOnRoute)
                            DataLeftRightContent(
                              descriptionLeft: Localize.of(context).notOnRoute,
                              descriptionRight: '',
                              rightWidget: Container(),
                            ),
                          if (rtu.user.isOnRoute) ...[
                            DataLeftRightContent(
                              descriptionLeft: Localize.of(context).timeToHead,
                              descriptionRight:
                                  '${TimeConverter.millisecondsToDateTimeString(value: rtu.timeUserToHead().abs(), maxvalue: 120 * 60 * 1000)}',
                              rightWidget: Container(
                                alignment: Alignment.centerRight,
                                width: 20,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/skatechildmunich.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            DataLeftRightContent(
                              descriptionLeft: Localize.of(context).timeToTail,
                              descriptionRight:
                                  '${TimeConverter.millisecondsToDateTimeString(value: rtu.timeUserToTail().abs(), maxvalue: 120 * 60 * 1000)}',
                              rightWidget: Container(
                                alignment: Alignment.centerRight,
                                width: 20,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/skatechildmunichred.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            DataLeftRightContent(
                              descriptionLeft:
                                  Localize.of(context).distanceToHead,
                              descriptionRight:
                                  '${((rtu.head.position - rtu.user.position) / 1000).abs().toStringAsFixed(2)} km',
                              rightWidget: Container(),
                            ),
                            DataLeftRightContent(
                              descriptionLeft:
                                  Localize.of(context).distanceToTail,
                              descriptionRight:
                                  '${((rtu.user.position - rtu.tail.position) / 1000).abs().toStringAsFixed(2)} km',
                              rightWidget: Container(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (friends.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(
                          '${Localize.of(context).friends} ${Localize.of(context).online}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  for (var friend in friends)
                    GestureDetector(
                      onTap: () {
                        /* showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return const FriendsPage();
                      });*/
                      },
                      child: Container(
                        color: CupertinoDynamicColor.resolve(
                            CupertinoColors.systemGroupedBackground, context),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundColor: friend.color,
                                  child: Text(friend.name.substring(0, 1)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(friend.name,
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                    DataLeftRightContent(
                                      descriptionRight:
                                          '${TimeConverter.millisecondsToDateTimeString(value: friend.timeToUser ?? 0)}',
                                      descriptionLeft:
                                          '${Localize.of(context).friendIs} ${(friend.timeToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}',
                                      rightWidget: (friend.latitude != null &&
                                              friend.longitude != null)
                                          ? GestureDetector(
                                              onTap: () {
                                                mapController.move(
                                                    LatLng(
                                                        friend.latitude ??
                                                            defaultLatitude,
                                                        friend.longitude ??
                                                            defaultLongitude),
                                                    15);
                                                Navigator.of(context).pop();
                                              },
                                              child: Icon(Icons.gps_fixed_sharp,
                                                  color:
                                                      CupertinoTheme.of(context)
                                                          .primaryColor,
                                                  size: 20),
                                            )
                                          : Container(),
                                    ),
                                    DataLeftRightContent(
                                        descriptionLeft:
                                            Localize.of(context).distance,
                                        descriptionRight:
                                            '${friend.distanceToUser ?? '-'} m',
                                        rightWidget: Container()),
                                    DataLeftRightContent(
                                        descriptionLeft:
                                            Localize.of(context).speed,
                                        descriptionRight:
                                            '${(friend.realSpeed.toStringAsFixed((1)))} km/h',
                                        rightWidget: Container())
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: Text(Localize.of(context).symbols,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (ref.watch(showOwnColoredTrackProvider)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(
                        Localize.of(context).mySpeed,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: SpeedInfoColors(),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                  GestureDetector(
                    child: Container(
                      color: CupertinoDynamicColor.resolve(
                          CupertinoColors.systemGroupedBackground, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).mapFollowLocation,
                            descriptionRight: '',
                            rightWidget: const ImageIcon(
                              AssetImage('assets/images/skater_icon_256.png'),
                              color: Colors.blue,
                            ),
                          ),
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).startParticipationTracking,
                            descriptionRight: '',
                            rightWidget: const Icon(
                              CupertinoIcons.play_arrow_solid,
                              color: Colors.green,
                            ),
                          ),
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).stopParticipationTracking,
                            descriptionRight: '',
                            rightWidget: const Icon(
                              CupertinoIcons.stop_circle_fill,
                              color: Colors.red,
                            ),
                          ),
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).autoStopTracking,
                            descriptionRight: '',
                            rightWidget: const Icon(Icons.pause,
                                color: CupertinoColors.systemYellow),
                          ),
                          DataLeftRightContent(
                            descriptionLeft:
                                Localize.of(context).showWeblinkToRoute,
                            descriptionRight: '',
                            rightWidget: const Icon(
                              CupertinoIcons.qrcode,
                              color: Colors.blue,
                            ),
                          ),
                          DataLeftRightContent(
                            descriptionLeft: Localize.of(context).scrollMapTo,
                            descriptionRight: '',
                            rightWidget: Icon(Icons.gps_fixed_sharp,
                                color: CupertinoTheme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
