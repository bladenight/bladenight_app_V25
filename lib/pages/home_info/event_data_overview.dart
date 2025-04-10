import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../generated/l10n.dart';
import '../../helpers/time_converter_helper.dart';
import '../../models/event.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../widgets/event_info/event_state_traffic_light.dart';
import 'event_map_small.dart';

///Event overview
///
/// Shows a widget with event name start and route information
/// - [nextEvent] set the [Event] to show
/// Optional
/// - [borderRadius] set the [Radius] for outer corners
/// - [showMap] hide map above the info if not needed
///    default false set to false to hide map
/// - [showSeparator] hide animated separator
/// - [eventIsRunning] hide parts if event is running
class EventDataOverview extends ConsumerStatefulWidget {
  const EventDataOverview({
    super.key,
    required this.nextEvent,
    this.borderRadius = 15.0,
    this.showMap = true,
    this.showSeparator = true,
    this.eventIsRunning = false,
  });

  final double borderRadius;
  final Event nextEvent;
  final bool showMap;
  final bool showSeparator;
  final bool eventIsRunning;

  @override
  ConsumerState<EventDataOverview> createState() => _EventDataOverviewState();
}

class _EventDataOverviewState extends ConsumerState<EventDataOverview>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _valueAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //call on first start
    });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var normalFontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize ?? 12;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showMap)
          GestureDetector(
            onTap: () {
              context.goNamed(AppRoute.map.name);
            },
            child: EventMapSmall(
                nextEvent: widget.nextEvent, borderRadius: widget.borderRadius),
          ),
        SizedBox(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!widget.eventIsRunning)
                    eventDetail(
                        textCrossedOut:
                            widget.nextEvent.status == EventStatus.cancelled,
                        context: context,
                        animation: _valueAnimation,
                        normalFontSize: normalFontSize,
                        dividerWidth: 110,
                        dividerColor: CupertinoTheme.of(context).primaryColor,
                        text: widget.nextEvent.status == EventStatus.noevent
                            ? Localize.of(context).noEventPlanned
                            : DateFormatter(Localize.of(context))
                                .getLocalDayDateTimeRepresentation(
                                    widget.nextEvent.getUtcIso8601DateTime),
                        description: Localize.of(context).nextEvent,
                        showSeparator: widget.showSeparator),
                  if (MediaQuery.orientationOf(context) ==
                          Orientation.landscape &&
                      widget.nextEvent.status != EventStatus.noevent) ...[
                    eventDetail(
                        textCrossedOut:
                            widget.nextEvent.status == EventStatus.cancelled,
                        context: context,
                        animation: _valueAnimation,
                        normalFontSize: normalFontSize,
                        dividerWidth: 70,
                        dividerColor: CupertinoTheme.of(context).primaryColor,
                        text: widget.nextEvent.routeName,
                        description: Localize.of(context).route,
                        showSeparator: widget.showSeparator),
                    eventDetail(
                        textCrossedOut:
                            widget.nextEvent.status == EventStatus.cancelled,
                        context: context,
                        animation: _valueAnimation,
                        normalFontSize: normalFontSize,
                        dividerWidth: 70,
                        dividerColor: CupertinoTheme.of(context).primaryColor,
                        text: widget.nextEvent.formatDistance,
                        description: Localize.of(context).length,
                        showSeparator: widget.showSeparator)
                  ],
                ]),
          ),
        ),
        if (MediaQuery.orientationOf(context) == Orientation.portrait &&
            widget.nextEvent.status != EventStatus.noevent)
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                eventDetail(
                    textCrossedOut:
                        widget.nextEvent.status == EventStatus.cancelled,
                    context: context,
                    animation: _valueAnimation,
                    normalFontSize: normalFontSize,
                    dividerWidth: 70,
                    dividerColor: CupertinoTheme.of(context).primaryColor,
                    text: widget.nextEvent.routeName,
                    description: Localize.of(context).route,
                    showSeparator: false),
                eventDetail(
                    textCrossedOut:
                        widget.nextEvent.status == EventStatus.cancelled,
                    context: context,
                    animation: _valueAnimation,
                    normalFontSize: normalFontSize,
                    dividerWidth: 70,
                    dividerColor: CupertinoTheme.of(context).primaryColor,
                    text: widget.nextEvent.formatDistance,
                    description: Localize.of(context).length,
                    showSeparator: false)
              ],
            ),
          ),
        if (widget.nextEvent.status != EventStatus.noevent &&
            !widget.eventIsRunning &&
            widget.nextEvent.status != EventStatus.cancelled)
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${Localize.of(context).start} '
                  '${widget.nextEvent.getStartPoint.startPoint}',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: CupertinoTheme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        if (!widget.nextEvent.isNoEventPlanned)
          Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                widget.nextEvent.statusColor.withValues(alpha: 0.5),
                widget.nextEvent.statusColor,
                widget.nextEvent.statusColor.withValues(alpha: 0.5)
              ]),
              color: widget.nextEvent.statusColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius),
              ),
            ),
            child: EventStatusTrafficLight(event: widget.nextEvent),
          ),
      ],
    );
  }
}

///Widget to show eventDetail with description
Widget eventDetail(
    {required BuildContext context,
    required Animation<double> animation,
    required double normalFontSize,
    required double dividerWidth,
    required Color dividerColor,
    required String text,
    required String description,
    bool textCrossedOut = false,
    bool showSeparator = true}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: normalFontSize * 0.7,
                      color: CupertinoTheme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              if (showSeparator)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 2,
                    width: dividerWidth,
                    decoration: BoxDecoration(
                      color: dividerColor.withValues(alpha: 0.2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: dividerWidth * animation.value,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: <Color>[
                              dividerColor.withValues(alpha: 0.4),
                              dividerColor,
                            ]),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        decoration:
                            textCrossedOut ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w900,
                        color: CupertinoTheme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
