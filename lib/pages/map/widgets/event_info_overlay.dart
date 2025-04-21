import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/event.dart';

class EventInfoOverlay extends StatefulWidget {
  const EventInfoOverlay({super.key, required this.event});

  final Event event;

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
    return SafeArea(
      child: Stack(children: [
        Positioned(
          top: 20,
          left: 15,
          right: 15,
          child: Stack(
            children: [
              ClipPath(
                clipper: EventInfoClipper(),
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: kIsWeb
                          ? CupertinoTheme.of(context).barBackgroundColor
                          : CupertinoDynamicColor.resolve(
                              CupertinoColors.transparent, context),
                      child: Column(children: [
                        Center(
                          child: FittedBox(
                            child: Text(
                              '${Localize.of(context).route}: ${widget.event.routeName}  '
                              '${Localize.of(context).length}: ${(widget.event.routeLength / 1000).toStringAsFixed(1)} km  ',
                              overflow: TextOverflow.fade,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        if (widget.event.status != EventStatus.noevent &&
                            widget.event.status != EventStatus.unknown)
                          Center(
                            child: FittedBox(
                              child: FittedBox(
                                child: Text(
                                  '${Localize.of(context).at} ${Localize.current.dateTimeIntl(widget.event.startDate, widget.event.startDate)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (widget.event.startPoint != null)
                          Center(
                            child: FittedBox(
                              child: Text(
                                '${Localize.of(context).startPointTitle} ${widget.event.startPoint}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (widget.event.participants != 0)
                          Center(
                            child: FittedBox(
                              child: Text(
                                '${Localize.of(context).participant}: ${widget.event.participants}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (widget.event.status != EventStatus.noevent &&
                            widget.event.status != EventStatus.unknown)
                          Center(
                            child: FittedBox(
                              child: Text(
                                widget.event.statusText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class EventInfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 6;
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..moveTo(0, r)
      ..lineTo(0, height - r) //x0, y= 85-50-6 =29 //1
      ..quadraticBezierTo(0, height, r, height) //2
      ..lineTo(width / 2 * 0.8, height) //
      ..lineTo(width - r, height)
      ..quadraticBezierTo(width, height, width, height - r)
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
