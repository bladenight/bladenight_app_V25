library flutter_clip_shadow;

import 'package:flutter/widgets.dart';

class _ClipShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final List<BoxShadow> boxShadows;

  const _ClipShadowPainter({
    required this.clipper,
    required this.boxShadows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final shadow in boxShadows) {
      final spreadSize = Size(
        size.width + shadow.spreadRadius * 2,
        size.height + shadow.spreadRadius * 2,
      );
      final clipPath = clipper.getClip(spreadSize).shift(
            Offset(
              shadow.offset.dx - shadow.spreadRadius,
              shadow.offset.dy - shadow.spreadRadius,
            ),
          );
      final paint = shadow.toPaint();
      canvas.drawPath(clipPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Box Shadowing with clipper
///
/// Example:
/// ```
/// ClipShadow( boxShadows: [
///                   BoxShadow(
///                     //outer shadow
///                     offset: Offset(1.1, 1.1),
///                     blurRadius: 10.0,
///                     blurStyle: BlurStyle.outer,
///                     spreadRadius: 0.0, //zero padding
///                     color: Colors.red,
///                   ),
///                ],
///            clipper: InfoClipper(),
///            child: Text('ABC'),
///               );```
///
class ClipShadow extends StatelessWidget {
  /// A list of shadows cast by this box behind the box.
  final List<BoxShadow> boxShadows;

  /// If non-null, determines which clip to use.
  final CustomClipper<Path> clipper;

  /// The [Widget] below this widget in the tree.
  final Widget child;

  ClipShadow(
      {required this.boxShadows, required this.clipper, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowPainter(
        clipper: clipper,
        boxShadows: boxShadows,
      ),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}
