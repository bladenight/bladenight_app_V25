import 'package:flutter/cupertino.dart';

import '../../../models/event.dart';

class EventStatusTrafficLight extends StatelessWidget {
  final Event event;

  const EventStatusTrafficLight({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: TextStyle(
            color: event.statusTextColor,
            fontSize: CupertinoTheme.of(context).textTheme.textStyle.fontSize !=
                    null
                ? CupertinoTheme.of(context).textTheme.textStyle.fontSize! * 1.0
                : 14,
            fontWeight: FontWeight.w600),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(
              event.trafficLight,
              height: 15,
            ),
          ),
          WidgetSpan(
              child: SizedBox(
            width: 5,
          )),
          TextSpan(
            text: event.statusText,
          ),
          WidgetSpan(
              child: SizedBox(
            width: 5,
          )),
        ],
      ),
    );
  }
}
