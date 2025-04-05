import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../helpers/enums/tracking_type.dart';
import '../../../../helpers/logger/logger.dart';
import '../../../../helpers/time_converter_helper.dart';
import '../../../../models/event.dart';
import '../../../../providers/active_event_provider.dart';
import '../../../../providers/is_tracking_provider.dart';
import '../../../../providers/location_provider.dart';
import '../../../../providers/refresh_timer_provider.dart';
import '../../../widgets/common_widgets/no_connection_warning.dart';
import '../../../widgets/common_widgets/shadow_clipper.dart';
import '../map_event_informations.dart';
import '../special_function_info.dart';
import '../update_progress.dart';
import 'event_active_no_tracking_not_on_route_widget.dart';
import 'event_active_tracking_user_on_route_widget.dart';
import 'event_data_map_overview.dart';
import 'no_event_overlay.dart';
import 'track_only_overlay_widget.dart';
import 'updating_overlay_widget.dart';

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
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BnLog.verbose(text: 'Track_progress_overlay - initState');
      ref
          .read(locationProvider)
          .refreshRealtimeData(forceUpdate: true); //update in map
      ref.read(activeEventProvider.notifier).refresh(forceUpdate: true);
      ref.read(refreshTimerProvider.notifier).start();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BnLog.verbose(
        text: 'Track_progress_overlay - didChangeAppLifecycleState $state');
    if (state == AppLifecycleState.resumed) {
      ref.read(refreshTimerProvider.notifier).start();
    } else if (state == AppLifecycleState.paused) {
      ref.read(refreshTimerProvider.notifier).stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var rtu = ref.watch(realtimeDataProvider);
    var trackingType = ref.watch(trackingTypeProvider);
    if (trackingType == TrackingType.onlyTracking) {
      return TrackOnlyOverlayWidget();
    }
    var actualOrNextEvent = ref.watch(activeEventProvider);
    var eventIsActive = actualOrNextEvent.status == EventStatus.running ||
        (rtu != null && rtu.eventIsActive);
    //Error no data
    if (rtu == null ||
        rtu.rpcException != null ||
        actualOrNextEvent.rpcException != null) {
      return UpdatingOverlayWidget();
    }
    //RTU Data available but no event
    else if (actualOrNextEvent.status == EventStatus.noevent) {
      return NoEventOverlayWidget(
        event: actualOrNextEvent,
      );
    } else {
      return SafeArea(
        child: Stack(
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
                child: ClipShadow(
                  boxShadows: [
                    BoxShadow(
                      //outer shadow
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0.0,
                      color: actualOrNextEvent.statusColor,
                    ),
                  ],
                  clipper: InfoClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Stack(children: [
                      Builder(builder: (context) {
                        return Container(
                          color: CupertinoDynamicColor.resolve(
                              CupertinoColors.transparent, context),
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            const SpecialFunctionInfo(),
                            if (eventIsActive &&
                                ref.watch(isTrackingProvider) &&
                                rtu.user.isOnRoute)
                              EventActiveTrackingActiveUserOnRoute(),
                            if (eventIsActive &&
                                    !ref.watch(isTrackingProvider) ||
                                !rtu.user.isOnRoute)
                              EventActiveNoTrackingNotOnRouteWidget(),
                            if (eventIsActive)
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // estimated time of arrival is time from start
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        '⏱Σ ${TimeConverter.millisecondsToDateTimeString(value: rtu.timeTrainComplete(), maxvalue: 30 * 60 * 1000)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: CupertinoTheme.of(context)
                                                .primaryColor),
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: CupertinoTheme.of(context)
                                                .primaryColor,
                                          ),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: CupertinoTheme.of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    )
                                  ]),
                            if (rtu.rpcException == null) ...[
                              EventDataMapOverview(
                                nextEvent: actualOrNextEvent,
                                showMap: false,
                                showSeparator: false,
                                eventIsRunning: eventIsActive,
                              ),
                            ],
                            const UpdateProgress(),
                          ]),
                        );
                      }),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConnectionWarning(),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class InfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 12;
    double nozzleHeight = 35;
    double width = size.width;
    double height = size.height + 10;
    Path path = Path()
      ..moveTo(0, r)
      ..lineTo(0, height - nozzleHeight - r) //x0, y= 85-50-6 =29 //1
      ..quadraticBezierTo(
          0, height - nozzleHeight, r, height - nozzleHeight) //2
      ..lineTo(width / 2 - nozzleHeight * 0.8, height - nozzleHeight) //
      //nozzle
      ..conicTo(width / 2, height + nozzleHeight * 0.2,
          width / 2 + nozzleHeight * 0.8, height - nozzleHeight, 2)
      //end nozzle
      ..lineTo(width - r, height - nozzleHeight)
      ..quadraticBezierTo(
          width, height - nozzleHeight, width, height - r - nozzleHeight)
      ..lineTo(width, r)
      ..quadraticBezierTo(
          //corner right top
          width,
          0,
          width - r,
          0)
      ..lineTo(r, 0)
      ..quadraticBezierTo(
          //corner left top
          0,
          0,
          0,
          r)
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

double degToRadian(int degree) {
  return (pi / 180) * degree;
}
