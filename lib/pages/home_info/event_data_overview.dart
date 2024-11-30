import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../models/event.dart';
import '../widgets/hidden_admin_button.dart';
import 'event_map_small.dart';

class EventDataOverview extends ConsumerStatefulWidget {
  const EventDataOverview(
      {super.key,
      this.borderRadius = 15.0,
      required this.nextEvent,
      this.parentAnimationController});

  final double borderRadius;
  final Event nextEvent;
  final AnimationController? parentAnimationController;

  @override
  ConsumerState<EventDataOverview> createState() => _EventDataOverviewState();
}

class _EventDataOverviewState extends ConsumerState<EventDataOverview>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;
  late final Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _colorAnimation = ColorTween(
      begin: CupertinoColors.systemRed, //(0x00ffffff),
      end: CupertinoColors.systemGrey, // ,Color(0x00ffff00),
    ).animate(_animationController);
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print('tap on event map small');
              },
              child: EventMapSmall(nextEvent: widget.nextEvent),
            ),
            HiddenAdminButton(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 8, bottom: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        eventDetail(
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
                        ),
                        if (MediaQuery.orientationOf(context) ==
                                Orientation.landscape &&
                            widget.nextEvent.status != EventStatus.noevent) ...[
                          eventDetail(
                            context: context,
                            animation: _valueAnimation,
                            normalFontSize: normalFontSize,
                            dividerWidth: 70,
                            dividerColor:
                                CupertinoTheme.of(context).primaryColor,
                            text: widget.nextEvent.routeName,
                            description: Localize.of(context).route,
                          ),
                          eventDetail(
                            context: context,
                            animation: _valueAnimation,
                            normalFontSize: normalFontSize,
                            dividerWidth: 70,
                            dividerColor:
                                CupertinoTheme.of(context).primaryColor,
                            text: widget.nextEvent.formatDistance,
                            description: Localize.of(context).length,
                          )
                        ]
                      ]),
                ),
              ),
            ),
            if (MediaQuery.orientationOf(context) == Orientation.portrait &&
                widget.nextEvent.status != EventStatus.noevent)
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 8, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    eventDetail(
                      context: context,
                      animation: _valueAnimation,
                      normalFontSize: normalFontSize,
                      dividerWidth: 70,
                      dividerColor: CupertinoTheme.of(context).primaryColor,
                      text: widget.nextEvent.routeName,
                      description: Localize.of(context).route,
                    ),
                    eventDetail(
                      context: context,
                      animation: _valueAnimation,
                      normalFontSize: normalFontSize,
                      dividerWidth: 70,
                      dividerColor: CupertinoTheme.of(context).primaryColor,
                      text: widget.nextEvent.formatDistance,
                      description: Localize.of(context).length,
                    )
                  ],
                ),
              ),
            if (widget.nextEvent.status != EventStatus.noevent)
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 2, bottom: 2),
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${Localize.of(context).start} '
                      '${widget.nextEvent.getStartPoint.startPoint}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CupertinoTheme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  widget.nextEvent.statusColor.withOpacity(0.8),
                  widget.nextEvent.statusColor,
                  widget.nextEvent.statusColor.withOpacity(0.8)
                ]),
                color: widget.nextEvent.statusColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(widget.borderRadius),
                  bottomRight: Radius.circular(widget.borderRadius),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.nextEvent.statusText,
                  style: TextStyle(color: widget.nextEvent.statusTextColor),
                ),
              ),
            ),
          ]),
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
    required String description}) {
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
                          .withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  height: 4,
                  width: dividerWidth,
                  decoration: BoxDecoration(
                    color: dividerColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: dividerWidth * animation.value,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                            dividerColor.withOpacity(0.4),
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
