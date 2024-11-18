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

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.repeat();
      //call on first start
    });
    super.initState();
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
        gradient: LinearGradient(colors: <Color>[
          CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.0),
          CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.2),
          CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.4),
          widget.nextEvent.statusColor,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print('tap on eventmappsmall');
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
                          animationController: _animationController,
                          normalFontSize: normalFontSize,
                          dividerWidth: 110,
                          dividerColor:
                              widget.nextEvent.status == EventStatus.noevent
                                  ? Color(0xFF333333)
                                  : Color(0xFFFFFF3B),
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
                            animationController: _animationController,
                            normalFontSize: normalFontSize,
                            dividerWidth: 70,
                            dividerColor: Color(0xFFFFFF3B),
                            text: widget.nextEvent.routeName,
                            description: Localize.of(context).route,
                          ),
                          eventDetail(
                            context: context,
                            animationController: _animationController,
                            normalFontSize: normalFontSize,
                            dividerWidth: 70,
                            dividerColor: Color(0xFFFFFF3B),
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
                  children: <Widget>[
                    eventDetail(
                      context: context,
                      animationController: _animationController,
                      normalFontSize: normalFontSize,
                      dividerWidth: 70,
                      dividerColor: Color(0xFF87A0E5),
                      text: widget.nextEvent.routeName,
                      description: Localize.of(context).route,
                    ),
                    eventDetail(
                      context: context,
                      animationController: _animationController,
                      normalFontSize: normalFontSize,
                      dividerWidth: 70,
                      dividerColor: Color(0xFF87A0E5),
                      text: widget.nextEvent.formatDistance,
                      description: Localize.of(context).length,
                    )
                  ],
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
    required AnimationController animationController,
    required double normalFontSize,
    required double dividerWidth,
    required Color dividerColor,
    required String text,
    required String description}) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      CupertinoTheme.of(context).textTheme.textStyle.fontFamily,
                  fontWeight: FontWeight.w200,
                  //fontSize: normalFontSize * 0.7, //fitted box not working if enabled
                  color:
                      CupertinoTheme.of(context).primaryColor.withOpacity(0.8),
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
                      width: dividerWidth * animationController.value,
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
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                    //fontSize: normalFontSize * 1.2,
                    color:
                        CupertinoTheme.of(context).primaryColor.withOpacity(1)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
