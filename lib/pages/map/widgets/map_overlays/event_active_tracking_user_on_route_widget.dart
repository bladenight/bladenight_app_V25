import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../helpers/hive_box/hive_settings_db.dart';
import '../../../../models/event.dart';
import '../../../../providers/active_event_provider.dart';
import '../../../../providers/is_tracking_provider.dart';
import '../../../../providers/location_provider.dart';
import '../../../../providers/map/icon_size_provider.dart';
import '../../../../providers/settings/me_color_provider.dart';
import '../progresso_advanced_progress_indicator.dart';

class EventActiveTrackingActiveUserOnRoute extends ConsumerWidget {
  const EventActiveTrackingActiveUserOnRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rtu = ref.watch(realtimeDataProvider);
    var isTracking = ref.watch(isTrackingProvider);
    var actualOrNextEvent = ref.watch(activeEventProvider);
    var eventIsActive = actualOrNextEvent.status == EventStatus.running ||
        (rtu != null && rtu.eventIsActive);
    if (rtu == null) {
      return Container();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Column(children: <Widget>[
        SizedBox(
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '↦${((rtu.user.position) / 1000).toStringAsFixed(1)} km   ${((rtu.user.position) / rtu.runningLength * 100).toStringAsFixed(1)} %  ⇥${((rtu.runningLength - rtu.user.position) / 1000).toStringAsFixed(1)} km',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: CupertinoTheme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        Column(children: [
          SizedBox(
            height: 10,
            child: Progresso(
                //head and tail
                progressStrokeWidth: 6,
                points: [
                  rtu.runningLength == 0
                      ? 0
                      : rtu.tail.position / rtu.runningLength,
                  rtu.runningLength == 0
                      ? 0
                      : rtu.head.position / rtu.runningLength
                ],
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                pointColor: CupertinoTheme.of(context)
                    .primaryColor
                    .withValues(alpha: 0.8),
                progressColor: CupertinoTheme.of(context).primaryColor,
                start: rtu.runningLength == 0
                    ? 0
                    : rtu.tail.position / (rtu.runningLength),
                progress: rtu.runningLength == 0
                    ? 0
                    : rtu.head.position / rtu.runningLength),
          ),
          SizedBox(
            height: 0,
            child: Progresso(
                //user
                backgroundColor: Colors.grey.withValues(alpha: 0.5),
                progressStrokeWidth: 6,
                points: [
                  0,
                  rtu.runningLength == 0
                      ? 0
                      : rtu.user.position / rtu.runningLength
                ],
                pointColor: Colors.black,
                progressColor:
                    ref.watch(meColorProvider).withValues(alpha: 0.8),
                start: 0,
                progress: rtu.runningLength == 0
                    ? 0
                    : rtu.user.position / rtu.runningLength),
          ),
        ]),
        if (eventIsActive)
          const SizedBox(
            height: 5,
          ),
        if (eventIsActive)
          Stack(children: [
            //tail
            Align(
              alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      rtu.runningLength == 0
                          ? 0
                          : rtu.tail.position / rtu.runningLength)
                  as AlignmentGeometry,
              child: SizedBox(
                height: MediaQuery.textScalerOf(context).scale(20),
                width: MediaQuery.textScalerOf(context).scale(20),
                child: const Center(
                  child: CircleAvatar(
                    child: Image(
                      image: AssetImage(
                        'assets/images/skatechildmunichred.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //head
            Align(
              alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      rtu.runningLength == 0
                          ? 0
                          : rtu.head.position / rtu.runningLength)
                  as AlignmentGeometry,
              child: SizedBox(
                height: MediaQuery.textScalerOf(context).scale(20),
                width: MediaQuery.textScalerOf(context).scale(20),
                child: Image(
                  image: const AssetImage(
                    'assets/images/skatechildmunichgreen.png',
                  ),
                  fit: BoxFit.fill,
                  height: MediaQuery.textScalerOf(context).scale(20),
                  width: MediaQuery.textScalerOf(context).scale(20),
                ),
              ),
            ),
            //user
            Align(
              alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      rtu.runningLength == 0
                          ? 0
                          : (rtu.user.position / rtu.runningLength) - 0.015)
                  as AlignmentGeometry,
              //need correction of center
              child: SizedBox(
                width: MediaQuery.textScalerOf(context).scale(18),
                height: MediaQuery.textScalerOf(context).scale(18),
                child: CircleAvatar(
                  radius: MediaQuery.textScalerOf(context)
                      .scale(ref.watch(iconSizeProvider)),
                  backgroundColor:
                      CupertinoTheme.of(context).barBackgroundColor,
                  child: CircleAvatar(
                    backgroundColor: CupertinoTheme.of(context).primaryColor,
                    child: ref.watch(isUserParticipatingProvider)
                        ? ImageIcon(
                            size: MediaQuery.textScalerOf(context)
                                .scale(ref.watch(iconSizeProvider) - 10),
                            const AssetImage(
                                'assets/images/skater_icon_256.png'),
                            color: ref.watch(meColorProvider),
                          )
                        : Icon(
                            Icons.compass_calibration_rounded,
                            color: ref.watch(meColorProvider),
                          ),
                  ),
                ),
              ),
            ),
            //friends
            if (isTracking &&
                rtu.rpcException != null &&
                rtu.user.isOnRoute &&
                !HiveSettingsDB.wantSeeFullOfProcession)
              for (var friend in rtu.mapPointFriends(rtu.friends))
                Align(
                  alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      rtu.runningLength > 0.0
                          ? friend.relativeDistance / rtu.runningLength
                          : 0.0) as AlignmentGeometry,
                  child: SizedBox(
                    width: MediaQuery.textScalerOf(context).scale(20),
                    height: MediaQuery.textScalerOf(context).scale(20),
                    child: CircleAvatar(
                      backgroundColor: friend.color,
                      child: Text(friend.name.substring(0, 1)),
                    ),
                  ),
                ),
          ]),
      ]),
    );
  }
}
