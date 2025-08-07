import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../../../helpers/time_converter_helper.dart';
import '../../../../models/event.dart';
import '../../../../providers/active_event_provider.dart';
import '../../../../providers/is_tracking_provider.dart';
import '../../../../providers/location_provider.dart';
import '../../../widgets/animated/shimmer_widget.dart';
import '../progresso_advanced_progress_indicator.dart';

class EventActiveNoTrackingNotOnRouteWidget extends ConsumerWidget {
  const EventActiveNoTrackingNotOnRouteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var normalFontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize ?? 12;
    var isTracking = ref.watch(isTrackingProvider);
    var rtu = ref.watch(realtimeDataProvider);
    var actualOrNextEvent = ref.watch(activeEventProvider);
    var eventIsActive = actualOrNextEvent.status == EventStatus.running ||
        (rtu != null && rtu.eventIsActive);
    if (rtu == null) {
      return Container();
    }
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Column(children: <Widget>[
        if (!kIsWeb)
          SizedBox(
            child: Center(
              child: (!rtu.user.isOnRoute && !isTracking)
                  ? (eventIsActive)
                      ? FittedBox(
                          child: Text(
                            Localize.of(context).bladenighttracking,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: normalFontSize * 0.7,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                        ) //Text when Event confirmed
                      : Container()
                  /*FittedBox(
                                                  child: Text(
                                                    '${actualOrNextEvent.status == EventStatus.finished ? Localize.of(context).finished : Localize.of(context).nextEvent} ${actualOrNextEvent.status == EventStatus.finished ? '' : ' ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}'}',
                                                  ),
                                                ) */ //empty when not confirmed no viewer mode available
                  : !isTracking
                      ? Text(Localize.of(context).bladenighttracking)
                      : ref.watch(isUserParticipatingProvider)
                          //tracking in viewer mode not participating
                          ? (actualOrNextEvent.status ==
                                      EventStatus.confirmed ||
                                  actualOrNextEvent.status ==
                                      EventStatus.running)
                              ? eventIsActive
                                  ? Text(
                                      Localize.of(context).notOnRoute,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor),
                                    )
                                  : Shimmer(
                                      gradient: LinearGradient(colors: [
                                        actualOrNextEvent.statusColor
                                            .withValues(alpha: 0.8),
                                        actualOrNextEvent.statusColor,
                                        actualOrNextEvent.statusColor
                                            .withValues(alpha: 0.8)
                                      ]),
                                      child: Text(
                                        Localize.of(context)
                                            .locationServiceRunning,
                                      ),
                                    ) /*Text(
                                                              '${Localize.of(context).start} ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}',
                                                            )*/
                              : Container()
                          : Text(
                              Localize.of(context).bladenightViewerTracking,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color:
                                      CupertinoTheme.of(context).primaryColor),
                            ),
            ),
          ),
        if (kIsWeb) ...[
          SizedBox(
            child: Center(
                child: ((actualOrNextEvent.status == EventStatus.confirmed ||
                            actualOrNextEvent.status == EventStatus.running) &&
                        eventIsActive)
                    ? Text(
                        '${Localize.of(context).showProcession} '
                        '${Localize.of(context).lastupdate} '
                        '${DateFormatter(Localize.of(context)).getFullDateTimeString(rtu.timeStamp)}',
                      ) //Text when Event confirmed
                    : Container()),
          ),
          if (!isTracking)
            Container()
          else
            ref.watch(isUserParticipatingProvider)
                //tracking in viewer mode  participating
                ? (actualOrNextEvent.status == EventStatus.confirmed ||
                        actualOrNextEvent.status == EventStatus.running)
                    ? Shimmer(
                        gradient: LinearGradient(colors: [
                          actualOrNextEvent.statusColor.withValues(alpha: 0.8),
                          actualOrNextEvent.statusColor,
                          actualOrNextEvent.statusColor.withValues(alpha: 0.8)
                        ]),
                        child: Text(
                          Localize.of(context).bladenightViewerTracking,
                        ),
                      ) /*Text(
                                                              '${Localize.of(context).start} ${DateFormatter(Localize.of(context)).getLocalDayDateTimeRepresentation(actualOrNextEvent.getUtcIso8601DateTime)}',
                                                        )*/
                    : Container()
                //tracking in viewer mode not participating
                : Text(
                    Localize.of(context).bladenightViewerTracking,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: CupertinoTheme.of(context).primaryColor),
                  )
        ],
        if (eventIsActive)
          Column(children: [
            SizedBox(
              height: 15,
              child: Progresso(
                  backgroundColor:
                      CupertinoColors.systemGrey.withValues(alpha: 0.5),
                  points: [
                    rtu.runningLength == 0
                        ? 0
                        : rtu.tail.position / rtu.runningLength,
                    rtu.runningLength == 0
                        ? 0
                        : rtu.head.position / rtu.runningLength
                  ],
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
          ]),
        if (eventIsActive)
          Stack(children: [
            Align(
              alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      rtu.runningLength == 0
                          ? 0
                          : rtu.head.position / rtu.runningLength)
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
                          : rtu.tail.position / rtu.runningLength)
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
    );
  }
}
