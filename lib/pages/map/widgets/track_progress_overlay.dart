import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/event.dart';
import '../../../providers/active_event_provider.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import '../../../providers/settings/me_color_provider.dart';
import '../../../providers/realtime_data_provider.dart';
import '../../../providers/refresh_timer_provider.dart';
import 'map_event_informations.dart';
import 'progresso_advanced_progress_indicator.dart';
import 'special_function_info.dart';
import 'update_progress.dart';

///Overlay to show progress in top of map
///
/// @param map controller map controller
///
class TrackProgressOverlay extends ConsumerStatefulWidget {
  const TrackProgressOverlay(this.controller, {super.key});

  final MapController controller;

  @override
  ConsumerState<TrackProgressOverlay> createState() =>
      _TrackProgressOverlayState();
}

class _TrackProgressOverlayState extends ConsumerState<TrackProgressOverlay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(locationProvider).refresh(forceUpdate: true); //update in map
      ref.read(activeEventProvider.notifier).refresh(forceUpdate: true);
      ref.read(refreshTimerProvider.notifier).start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid || Platform.isIOS) {
      BnLog.debug(
          text: 'Track_progress_overlay - didChangeAppLifecycleState $state');
    }
    if (state == AppLifecycleState.resumed) {
      ref.read(refreshTimerProvider.notifier).start();
    } else if (state == AppLifecycleState.paused) {
      ref.read(refreshTimerProvider.notifier).stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var rtu = ref.watch(realtimeDataProvider);
    var actualOrNextEvent = ref.watch(activeEventProvider);
    var eventIsActive = actualOrNextEvent.status == EventStatus.running ||
        (rtu != null && rtu.eventIsActive);
    if (actualOrNextEvent.status == EventStatus.noevent) {
      return Stack(children: [
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 15,
          right: 15,
          child: ClipPath(
            clipper: InfoClipper(),
            child: Stack(children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Builder(builder: (context) {
                  return Container(
                    color: CupertinoDynamicColor.resolve(
                        CupertinoColors.systemBackground.withOpacity(0.2),
                        context),
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Column(children: [
                        Text(
                          Localize.of(context).noEventPlanned,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (actualOrNextEvent.rpcException != null)
                          Text(Localize.of(context).dataCouldBeOutdated),
                      ]),
                    ),
                  );
                }),
              ),
            ]),
          ),
        ),
      ]);
    } else {
      return Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
            child: GestureDetector(
              onLongPress: () async {},
              onTap: () {
                showCupertinoModalBottomSheet(
                    backgroundColor: CupertinoDynamicColor.resolve(
                        CupertinoColors.systemBackground, context),
                    context: context,
                    builder: (context) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: kIsWeb
                              ? MediaQuery.of(context).size.height * 0.5
                              : MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: MapEventInformation(
                          mapController: widget.controller,
                        ),
                      );
                    });
              },
              child: ClipPath(
                clipper: InfoClipper(),
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Builder(builder: (context) {
                      if (rtu == null) {
                        return Container(
                          color: CupertinoDynamicColor.resolve(
                              CupertinoColors.systemBackground.withOpacity(0.2),
                              context),
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(children: [
                              Text(
                                Localize.of(context).nodatareceived,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navTitleTextStyle,
                              ),
                              Center(
                                child: Align(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Stack(children: [
                                      Align(
                                        child: CircularProgressIndicator(
                                          color: CupertinoTheme.of(context)
                                              .primaryColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      }

                      return Container(
                        color: CupertinoDynamicColor.resolve(
                            CupertinoColors.systemBackground.withOpacity(0.1),
                            context),
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          if (eventIsActive &&
                              ref.watch(isTrackingProvider) &&
                              rtu.user.isOnRoute)
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Column(children: <Widget>[
                                SizedBox(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '↦${((rtu.user.position) / 1000).toStringAsFixed(1)} km   ${((rtu.user.position) / rtu.runningLength * 100).toStringAsFixed(1)} %  ⇥${((rtu.runningLength - rtu.user.position) / 1000).toStringAsFixed(1)} km',
                                      textAlign: TextAlign.center,
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
                                              : rtu.tail.position /
                                                  rtu.runningLength,
                                          rtu.runningLength == 0
                                              ? 0
                                              : rtu.head.position /
                                                  rtu.runningLength
                                        ],
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                        pointColor: CupertinoTheme.of(context)
                                            .primaryColor
                                            .withOpacity(0.8),
                                        progressColor:
                                            CupertinoTheme.of(context)
                                                .primaryColor,
                                        start: rtu.runningLength == 0
                                            ? 0
                                            : rtu.tail.position /
                                                (rtu.runningLength),
                                        progress: rtu.runningLength == 0
                                            ? 0
                                            : rtu.head.position /
                                                rtu.runningLength),
                                  ),
                                  SizedBox(
                                    height: 0,
                                    child: Progresso(
                                        //user
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.5),
                                        progressStrokeWidth: 6,
                                        points: [
                                          0,
                                          rtu.runningLength == 0
                                              ? 0
                                              : rtu.user.position /
                                                  rtu.runningLength
                                        ],
                                        pointColor: Colors.black,
                                        progressColor: ref
                                            .watch(meColorProvider)
                                            .withOpacity(0.8),
                                        start: 0,
                                        progress: rtu.runningLength == 0
                                            ? 0
                                            : rtu.user.position /
                                                rtu.runningLength),
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
                                                  : rtu.tail.position /
                                                      rtu.runningLength)
                                          as AlignmentGeometry,
                                      child: SizedBox(
                                        height: MediaQuery.textScalerOf(context)
                                            .scale(20),
                                        width: MediaQuery.textScalerOf(context)
                                            .scale(20),
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
                                                  : rtu.head.position /
                                                      rtu.runningLength)
                                          as AlignmentGeometry,
                                      child: SizedBox(
                                        height: MediaQuery.textScalerOf(context)
                                            .scale(20),
                                        width: MediaQuery.textScalerOf(context)
                                            .scale(20),
                                        child: Image(
                                          image: const AssetImage(
                                            'assets/images/skatechildmunichgreen.png',
                                          ),
                                          fit: BoxFit.fill,
                                          height:
                                              MediaQuery.textScalerOf(context)
                                                  .scale(20),
                                          width:
                                              MediaQuery.textScalerOf(context)
                                                  .scale(20),
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
                                              : (rtu.user.position /
                                                      rtu.runningLength) -
                                                  0.015) as AlignmentGeometry,
                                      //need correction of center
                                      child: SizedBox(
                                        width: MediaQuery.textScalerOf(context)
                                            .scale(18),
                                        height: MediaQuery.textScalerOf(context)
                                            .scale(18),
                                        child: CircleAvatar(
                                          radius: MediaQuery.textScalerOf(
                                                  context)
                                              .scale(
                                                  ref.watch(iconSizeProvider)),
                                          backgroundColor:
                                              CupertinoTheme.of(context)
                                                  .barBackgroundColor,
                                          child: CircleAvatar(
                                            backgroundColor:
                                            CupertinoTheme.of(context).primaryColor,
                                            child: ref.watch(
                                                    isUserParticipatingProvider)
                                                ? ImageIcon(
                                                    size: MediaQuery
                                                            .textScalerOf(
                                                                context)
                                                        .scale(ref.watch(
                                                                iconSizeProvider) -
                                                            10),
                                                    const AssetImage(
                                                        'assets/images/skater_icon_256.png'),
                                                    color: ref
                                                        .watch(meColorProvider),
                                                  )
                                                : Icon(
                                                    Icons
                                                        .compass_calibration_rounded,
                                                    color: ref
                                                        .watch(meColorProvider),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //friends
                                    if (ref.watch(isTrackingProvider) &&
                                        rtu.rpcException != null &&
                                        rtu.user.isOnRoute &&
                                        !HiveSettingsDB.wantSeeFullOfProcession)
                                      for (var friend
                                          in rtu.mapPointFriends(rtu.friends))
                                        Align(
                                          alignment: Alignment.lerp(
                                              Alignment.topLeft,
                                              Alignment.topRight,
                                              rtu.runningLength > 0.0
                                                  ? friend.relativeDistance /
                                                      rtu.runningLength
                                                  : 0.0) as AlignmentGeometry,
                                          child: SizedBox(
                                            width:
                                                MediaQuery.textScalerOf(context)
                                                    .scale(20),
                                            height:
                                                MediaQuery.textScalerOf(context)
                                                    .scale(20),
                                            child: CircleAvatar(
                                              backgroundColor: friend.color,
                                              child: Text(
                                                  friend.name.substring(0, 1)),
                                            ),
                                          ),
                                        ),
                                  ]),
                              ]),
                            ),
                          if (eventIsActive && !ref.watch(isTrackingProvider) ||
                              !rtu.user.isOnRoute)
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Column(children: <Widget>[
                                if (!kIsWeb)
                                  SizedBox(
                                    child: Center(
                                      child: (!rtu.user.isOnRoute &&
                                              !ref.watch(isTrackingProvider))
                                          ? (eventIsActive)
                                              ? FittedBox(
                                                  child: Text(
                                                      Localize.of(context)
                                                          .bladenighttracking),
                                                ) //Text when Event confirmed
                                              : FittedBox(
                                                  child: Text(
                                                    '${actualOrNextEvent.status == EventStatus.finished ? Localize.of(context).finished : Localize.of(context).nextEvent} ${actualOrNextEvent.status == EventStatus.finished ? '' : ' ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}'}',
                                                  ),
                                                ) //empty when not confirmed no viewer mode available
                                          : !ref.watch(isTrackingProvider)
                                              ? Text(Localize.of(context)
                                                  .bladenighttracking)
                                              : ref.watch(
                                                      isUserParticipatingProvider)
                                                  //tracking in viewer mode not participating
                                                  ? (actualOrNextEvent.status ==
                                                              EventStatus
                                                                  .confirmed ||
                                                          actualOrNextEvent
                                                                  .status ==
                                                              EventStatus
                                                                  .running)
                                                      ? eventIsActive
                                                          ? Text(Localize.of(
                                                                  context)
                                                              .notOnRoute)
                                                          : Text(
                                                              '${Localize.of(context).start} ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}',
                                                            )
                                                      : Container()
                                                  : Text(Localize.of(context)
                                                      .bladenightViewerTracking),
                                    ),
                                  ),
                                if (kIsWeb)
                                  SizedBox(
                                      child: Center(
                                          child: (actualOrNextEvent.status ==
                                                      EventStatus.confirmed ||
                                                  actualOrNextEvent.status ==
                                                      EventStatus.running)
                                              ? Text(
                                                  '${Localize.of(context).showProcession} ${Localize.of(context).lastupdate} ${DateFormatter(Localize.of(context)).getFullDateTimeString(rtu.timeStamp)}') //Text when Event confirmed
                                              : (actualOrNextEvent.status !=
                                                          EventStatus
                                                              .confirmed ||
                                                      actualOrNextEvent
                                                              .status ==
                                                          EventStatus.running)
                                                  ? kIsWeb
                                                      ? FittedBox(
                                                          child: Text(
                                                            '${Localize.of(context).nextEvent} ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}',
                                                          ),
                                                        )
                                                      : FittedBox(
                                                          child: Text(
                                                            DateFormatter(
                                                                    Localize.of(
                                                                        context))
                                                                .getLocalDayDateTimeRepresentation(
                                                                    actualOrNextEvent
                                                                        .getUtcIso8601DateTime),
                                                          ),
                                                        )
                                                  : Container()) //empty when not confirmed no viewer mode available
                                      ),
                                if (eventIsActive)
                                  Column(children: [
                                    SizedBox(
                                      height: 15,
                                      child: Progresso(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.5),
                                          points: [
                                            rtu.runningLength == 0
                                                ? 0
                                                : rtu.tail.position /
                                                    rtu.runningLength,
                                            rtu.runningLength == 0
                                                ? 0
                                                : rtu.head.position /
                                                    rtu.runningLength
                                          ],
                                          pointColor: CupertinoTheme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                          progressColor:
                                              CupertinoTheme.of(context)
                                                  .primaryColor,
                                          start: rtu.runningLength == 0
                                              ? 0
                                              : rtu.tail.position /
                                                  (rtu.runningLength),
                                          progress: rtu.runningLength == 0
                                              ? 0
                                              : rtu.head.position /
                                                  rtu.runningLength),
                                    ),
                                  ]),
                                if (eventIsActive)
                                  Stack(children: [
                                    Align(
                                      alignment: Alignment.lerp(
                                              Alignment.topLeft,
                                              Alignment.topRight,
                                              rtu.runningLength == 0
                                                  ? 0
                                                  : rtu.head.position /
                                                      rtu.runningLength)
                                          as AlignmentGeometry,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/skatechildmunichgreen.png',
                                        ),
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.lerp(
                                              Alignment.topLeft,
                                              Alignment.topRight,
                                              rtu.runningLength == 0
                                                  ? 0
                                                  : rtu.tail.position /
                                                      rtu.runningLength)
                                          as AlignmentGeometry,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/skatechildmunichred.png',
                                        ),
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ]),
                              ]),
                            ),
                          if (eventIsActive)
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // estimated time of arrival is time from start
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      '⏱ Σ ${TimeConverter.millisecondsToDateTimeString(value: rtu.timeTrainComplete(), maxvalue: 120 * 60 * 1000)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (ref.watch(isTrackingProvider))
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        '⇥ ${TimeConverter.millisecondsToDateTimeString(value: rtu.timeUserToTail(), maxvalue: 120 * 60 * 1000)}',
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      '📏 ${(rtu.distanceOfTrainComplete() / 1000).toStringAsFixed(1)} km',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      softWrap: false,
                                    ),
                                  )
                                ]),
                          const SpecialFunctionInfo(),
                          if (!actualOrNextEvent.isActive ||
                              actualOrNextEvent.status ==
                                  EventStatus.cancelled ||
                              actualOrNextEvent.status == EventStatus.pending)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: ([
                                Expanded(
                                  child: SizedBox(
                                    height: MediaQuery.textScalerOf(context)
                                        .scale(25),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      child: ColoredBox(
                                        color: actualOrNextEvent.status ==
                                                EventStatus.cancelled
                                            ? Colors.redAccent
                                            : Colors.blueGrey,
                                        child: FittedBox(
                                          child: Text(
                                            '${Localize.of(context).status} ${actualOrNextEvent.status == EventStatus.cancelled ? Localize.of(context).canceled : Localize.of(context).pending}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          if (rtu.rpcException == null) ...[
                            Center(
                              child: FittedBox(
                                child: Text(
                                  '${Localize.of(context).route}: ${rtu.routeName}  '
                                  '${Localize.of(context).length}: ${((rtu.runningLength) / 1000).toStringAsFixed(1)} km  '
                                  '${actualOrNextEvent.status == EventStatus.confirmed || actualOrNextEvent.status == EventStatus.running ? "${rtu.usersTracking.toString()} ${Localize.of(context).trackers}" : ""}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                          if (rtu.rpcException != null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: FittedBox(
                                  child:
                                      Text(Localize.of(context).nodatareceived),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          const UpdateProgress(),
                        ]),
                      );
                    }),
                  ),
                ]),
              ),
            ),
          ),
        ],
      );
    }
  }
}

class InfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 6;
    double rfactor = 0.55;
    double nozzleHeight = 35;
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..moveTo(0, r * 0.55)
      ..lineTo(0, height - nozzleHeight - r)
      ..quadraticBezierTo(
        //corner left bottom
        r * rfactor,
        height - nozzleHeight,
        r * 2 * rfactor,
        height - nozzleHeight,
      )
      ..lineTo(width / 2 - nozzleHeight / 2, height - nozzleHeight)

      //nozzle
      ..arcToPoint(Offset(width / 2, height - 5),
          radius: Radius.circular(nozzleHeight), clockwise: false)
      ..arcToPoint(Offset(width / 2 + nozzleHeight / 2, height - nozzleHeight),
          radius: Radius.circular(nozzleHeight), clockwise: false)
      //end nozzle
      ..lineTo(width - r, height - nozzleHeight)
      ..quadraticBezierTo(
        width - r * rfactor,
        height - nozzleHeight - r * rfactor,
        width,
        height - r - nozzleHeight,
      )

      //path.quadraticBezierTo(20, height - 20, 30, height);
      // path.lineTo(width, height - r - 30);
      ..lineTo(width, r * rfactor)
      ..quadraticBezierTo(
        //corner right top
        width - r * rfactor,
        r * rfactor,
        width - r * 2 * rfactor,
        0,
      )
      ..lineTo(r * 2 * rfactor, 0)
      ..quadraticBezierTo(
        //corner left top
        r * rfactor,
        r * rfactor,
        0,
        r * 2 * rfactor,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      return true;
    }
    return false;
  }
}
