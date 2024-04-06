import 'package:flutter/material.dart';

class PositionedVisibilityOpacity extends StatefulWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final Widget child;
  final bool visibility;
  final void Function()? onPressed;
  final String heroTag;
  final Duration duration;
  final Curve curve;
  final Color? backgroundColor;

  const PositionedVisibilityOpacity({
    /// Creates a widget that animates when visible or invisible with opacity.
    ///
    /// Only two out of the three horizontal values ([left], [right],
    /// [width]), and only two out of the three vertical values ([top],
    /// [bottom], [height]), can be set. In each case, at least one of
    /// the three must be null.
    super.key,
    required this.child,
    required this.visibility,
    required this.onPressed,
    required this.heroTag,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.backgroundColor,
  });

  @override
  State<PositionedVisibilityOpacity> createState() =>
      _PositionedVisibilityOpacityState();
}

class _PositionedVisibilityOpacityState
    extends State<PositionedVisibilityOpacity> {
  bool v = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      width: widget.width,
      height: widget.height,
      child: !widget.visibility
          ? const SizedBox()
          : Visibility(
              visible: widget.visibility,
              maintainAnimation: true,
              maintainState: true,
              child: AnimatedOpacity(
                duration: widget.duration,
                onEnd: () {
                  setState(() {
                    v = widget.visibility;
                  });
                },
                opacity: widget.visibility ? 1 : 0,
                curve: widget.curve,
                child: Builder(builder: (context) {
                  return FloatingActionButton(
                    backgroundColor: widget.backgroundColor,
                    onPressed: () {
                      if (v) {
                        if (widget.onPressed != null) {
                          widget.onPressed!();
                        }
                      }
                    },
                    heroTag: widget.heroTag,
                    child: widget.child,
                  );
                }),
              ),
            ),
    );
  }
}
