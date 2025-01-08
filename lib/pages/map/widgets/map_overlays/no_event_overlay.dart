import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../models/event.dart';
import '../../../home_info/event_data_overview.dart';
import 'overlay_clipper.dart';

class NoEventOverlayWidget extends StatelessWidget {
  const NoEventOverlayWidget({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
        child: ClipPath(
          clipper: InfoClipper2(),
          child: Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Builder(builder: (context) {
                return EventDataOverview(
                  nextEvent: event,
                  showMap: false,
                );
              }),
            ),
          ]),
        ),
      ),
    ]);
  }
}
