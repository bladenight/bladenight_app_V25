import 'package:flutter/material.dart';

/// Create a Positioned FloatingActionButton with animated Opacity on changing visibility
class PositionedVisibilityOpacity extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var v = true;
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: Visibility(
        visible: v,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
          duration: duration,
          onEnd: () => v = visibility,
          opacity: visibility ? 1 : 0,
          curve: curve,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              backgroundColor: backgroundColor,
              onPressed: onPressed,
              heroTag: heroTag,
              child: child,
            );
          }),
        ),
      ),
    );
  }
}
