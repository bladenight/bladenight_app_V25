import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../helpers/speed_to_color.dart';
import '../../../helpers/timeconverter_helper.dart';
import '../../../models/event.dart';
import '../../../models/realtime_update.dart';
import '../../../pages/widgets/no_connection_warning.dart';
import '../../../providers/active_event_notifier_provider.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/refresh_timer_provider.dart';
import '../../../providers/shared_prefs_provider.dart';
import 'map_event_informations.dart';
import 'progresso_advanced_progress_indicator.dart';

class TrackProgressOverlay extends ConsumerStatefulWidget {
  const TrackProgressOverlay({Key? key, required this.mapController})
      : super(key: key);
  final MapController mapController;

  @override
  ConsumerState<TrackProgressOverlay> createState() =>
      _TrackProgressOverlayState();
}

class _TrackProgressOverlayState extends ConsumerState<TrackProgressOverlay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider).refresh(forceUpdate: true); //update in map
      ref.read(activeEventProvider).refresh(forceUpdate: true);
      ref.read(refreshTimerProvider.notifier).start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid || Platform.isIOS) {
      FLog.debug(
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
    var location = ref.watch(locationProvider);
    var activeEvent = ref.watch(isActiveEventProvider);
    if (activeEvent.status == EventStatus.noevent) {
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
                        if (activeEvent.rpcException != null)
                          Text(Localize.of(context).dataCouldBeOutdated),
                        if (activeEvent.rpcException != null)
                          const ConnectionWarning(),
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
                        child: MapEventInformations(
                          mapController: widget.mapController,
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
                      if (location.realtimeUpdate == null) {
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
                      var rtu = location.realtimeUpdate as RealtimeUpdate;
                      return Container(
                        color: CupertinoDynamicColor.resolve(
                            CupertinoColors.systemBackground.withOpacity(0.1),
                            context),
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          if (location.isTracking && rtu.user.isOnRoute)
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
                                Stack(children: [
                                  SizedBox(
                                    height: 22,
                                    child: Progresso(
                                        points: [
                                          rtu.runningLength == 0
                                              ? 0
                                              : rtu.tail.position /
                                                  rtu.runningLength,
                                          rtu.runningLength == 0
                                              ? 0
                                              : rtu.user.position /
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
                                            CupertinoColors.activeGreen,
                                        start: rtu.runningLength == 0
                                            ? 0
                                            : rtu.tail.position /
                                                (rtu.runningLength),
                                        progress: rtu.runningLength == 0
                                            ? 0
                                            : rtu.head.position <
                                                    rtu.user.position
                                                ? rtu.user.position /
                                                    rtu.runningLength
                                                : rtu.head.position /
                                                    rtu.runningLength),
                                  ),
                                ]),
                                if (activeEvent.status ==
                                        EventStatus.confirmed ||
                                    activeEvent.status == EventStatus.running)
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
                                        height: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
                                        width: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
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
                                        height: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
                                        width: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
                                        child: Image(
                                          image: const AssetImage(
                                            'assets/images/skatechildmunichgreen.png',
                                          ),
                                          fit: BoxFit.fill,
                                          height: MediaQuery.of(context)
                                                  .textScaleFactor *
                                              20,
                                          width: MediaQuery.of(context)
                                                  .textScaleFactor *
                                              20,
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
                                        width: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
                                        height: MediaQuery.of(context)
                                                .textScaleFactor *
                                            20,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ref.watch(MeColor.provider),
                                          child: location.userIsParticipant
                                              ? const ImageIcon(AssetImage(
                                                  'assets/images/skaterIcon_256.png'))
                                              : const Icon(
                                                  Icons.gps_fixed_sharp),
                                        ),
                                      ),
                                    ),
                                    //friends
                                    if (location.isTracking &&
                                        rtu.rpcException != null &&
                                        rtu.user.isOnRoute &&
                                        location.realtimeUpdate != null &&
                                        location.realtimeUpdate.friends !=
                                            null &&
                                        !HiveSettingsDB.wantSeeFullOfProcession)
                                      for (var friend in location.realtimeUpdate
                                          .mapPointFriends(
                                              location.realtimeUpdate.friends))
                                        Align(
                                          alignment: Alignment.lerp(
                                              Alignment.topLeft,
                                              Alignment.topRight,
                                              rtu.runningLength > 0.0
                                                  ? friend.relativeDistance /
                                                      rtu.runningLength
                                                  : 0.0) as AlignmentGeometry,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                20,
                                            height: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                20,
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
                          if (!location.isTracking || !rtu.user.isOnRoute)
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Column(children: <Widget>[
                                if (!kIsWeb)
                                  SizedBox(
                                    child: Center(
                                      child: (!rtu.user.isOnRoute &&
                                              !location.isTracking)
                                          ? ((activeEvent.status ==
                                                      EventStatus.confirmed ||
                                                  activeEvent.status ==
                                                      EventStatus.running)
                                              ? FittedBox(
                                                  child: Text(
                                                      Localize.of(context)
                                                          .bladenighttracking),
                                                ) //Text when Event confirmed
                                              : FittedBox(
                                                  child: Text(
                                                    '${activeEvent.status == EventStatus.finished ? Localize.of(context).finished : Localize.of(context).nextEvent} ${activeEvent.status == EventStatus.finished ? '' : DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(activeEvent.getUtcIso8601DateTime)}',
                                                  ),
                                                )) //empty when not confirmed no viewer mode available
                                          : !location.isTracking
                                              ? Text(Localize.of(context)
                                                  .bladenighttracking)
                                              : location
                                                      .userIsParticipant //tracking in viewer mode not participating
                                                  ? activeEvent.status ==
                                                              EventStatus
                                                                  .confirmed ||
                                                          activeEvent.status ==
                                                              EventStatus
                                                                  .running
                                                      ? Text(
                                                          Localize.of(context)
                                                              .notOnRoute)
                                                      : Container()
                                                  : Text(Localize.of(context)
                                                      .bladenightViewerTracking),
                                    ),
                                  ),
                                if (kIsWeb)
                                  SizedBox(
                                      child: Center(
                                          child: (activeEvent.status ==
                                                      EventStatus.confirmed ||
                                                  activeEvent.status ==
                                                      EventStatus.running)
                                              ? Text(
                                                  '${Localize.of(context).showProcession} ${Localize.of(context).lastupdate} ${DateFormatter(Localize.of(context)).getFullDateTimeString(location.lastUpdate)}') //Text when Event confirmed
                                              : (activeEvent.status !=
                                                          EventStatus
                                                              .confirmed ||
                                                      activeEvent.status ==
                                                          EventStatus.running)
                                                  ? kIsWeb
                                                      ? FittedBox(
                                                          child: Text(
                                                            '${Localize.of(context).nextEvent} ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(activeEvent.getUtcIso8601DateTime)}',
                                                          ),
                                                        )
                                                      : FittedBox(
                                                          child: Text(
                                                            DateFormatter(
                                                                    Localize.of(
                                                                        context))
                                                                .getLocalDayDateTimeRepresentation(
                                                                    activeEvent
                                                                        .getUtcIso8601DateTime),
                                                          ),
                                                        )
                                                  : Container()) //empty when not confirmed no viewermode available
                                      ),
                                if (activeEvent.status ==
                                        EventStatus.confirmed ||
                                    activeEvent.status == EventStatus.running)
                                  Stack(children: [
                                    SizedBox(
                                      height: 20,
                                      child: Progresso(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.2),
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
                                if (activeEvent.status ==
                                        EventStatus.confirmed ||
                                    activeEvent.status == EventStatus.running)
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
                          if (activeEvent.status == EventStatus.confirmed ||
                              activeEvent.status == EventStatus.running)
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
                                  if (location.isTracking)
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
                          if (HiveSettingsDB.wantSeeFullOfProcession)
                            Align(
                              child: StepProgressIndicator(
                                totalSteps: SpeedToColor.speedColors.length,
                                direction: Axis.horizontal,
                                currentStep: SpeedToColor.speedColors.length,
                                size: 12,
                                unselectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: SpeedToColor.speedColors,
                                ),
                                selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: SpeedToColor.speedColors,
                                ),
                              ),
                            ),
                          if (activeEvent.status == EventStatus.cancelled ||
                              activeEvent.status == EventStatus.pending)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: ([
                                Expanded(
                                  child: SizedBox(
                                    height:
                                        MediaQuery.textScaleFactorOf(context) *
                                            25,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      child: ColoredBox(
                                        color: activeEvent.status ==
                                                EventStatus.cancelled
                                            ? Colors.redAccent
                                            : Colors.blueGrey,
                                        child: FittedBox(
                                          child: Text(
                                            '${Localize.of(context).status} ${activeEvent.status == EventStatus.cancelled ? Localize.of(context).canceled : Localize.of(context).pending}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          Center(
                            child: FittedBox(
                              child: Text(
                                '${Localize.of(context).route}: ${rtu.routeName}  '
                                '${Localize.of(context).length}: ${((rtu.runningLength) / 1000).toStringAsFixed(1)} km  '
                                '${activeEvent.status == EventStatus.confirmed || activeEvent.status == EventStatus.running ? "${rtu.usersTracking.toString()} ${Localize.of(context).trackers}" : ""}',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Align(
                            child: SizedBox(
                              width: 25,
                              height: 25,
                              child: Stack(children: [
                                Align(
                                  child: CircularProgressIndicator(
                                    color:
                                        CupertinoTheme.of(context).primaryColor,
                                    value: ref.watch(percentLeftProvider),
                                    strokeWidth: 2,
                                  ),
                                ),
                                Align(
                                  child: Icon(CupertinoIcons.info_circle_fill,
                                      color: CupertinoTheme.of(context)
                                          .primaryColor),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      );
                    }),
                  ),
                ]),
              ),
            ),
          ),
          if (!kIsWeb) const ConnectionWarning(),
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
