import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/event.dart';
import '../../../models/route.dart' hide Path;

class EventInfoOverlay extends StatefulWidget {
  const EventInfoOverlay(
      {Key? key, required this.event, required this.routePoints})
      : super(key: key);
  final Event event;
  final RoutePoints? routePoints;

  @override
  State<EventInfoOverlay> createState() => _EventInfoOverlayState();
}

class _EventInfoOverlayState extends State<EventInfoOverlay> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          left: 15,
          right: 15,
          child: ClipPath(
            clipper: EventInfoClipper(),
            child: Stack(children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(children: [
                  Center(
                    child: FittedBox(
                      child: Text(
                        '${Localize.of(context).route}: ${widget.event.routeName}  '
                        '${Localize.of(context).length}: ${widget.routePoints != null ? ((widget.routePoints!.getRoutePointsSummaryDistance)/1000).toStringAsFixed(1) : '-'} km  ',
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Center(
                      child: FittedBox(
                          child: FittedBox(
                    child: Text(
                      '${Localize.of(context).at} ${Localize.current.dateTimeIntl(widget.event.startDate, widget.event.startDate)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))),
                ]),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class EventInfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 6;
    double rfactor = 0.55;
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..moveTo(0, r * 0.55)
      ..lineTo(0, height - r)
      ..quadraticBezierTo(
        //corner left bottom
        r * rfactor,
        height,
        r * 2 * rfactor,
        height,
      )
      ..lineTo(width - r, height)
      ..quadraticBezierTo(
        width - r * rfactor,
        height - r * rfactor,
        width,
        height - r,
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
