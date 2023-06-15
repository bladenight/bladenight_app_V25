/*
Copyright 2021 Russ biggs
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

library progresso;

import 'package:flutter/material.dart';

///
class Progresso extends StatefulWidget {
  /// The starting position of the progress bar. Defaults to 0.0 must be less
  /// than 1.0
  final double start;

  /// The progress position of the progress bar. Defaults to 0.0 must be less
  /// than 1.0 and greater than start.
  final double progress;

  /// a List of double values that are represented on the progress line as
  /// points. Must be greater than or equal to 0.0 and less than or equal to 1.0
  final List<double> points;

  /// The Color of the progress bar
  final Color progressColor;

  /// The color of the background bar
  final Color backgroundColor;

  /// The stroke width of the progress bar
  final double progressStrokeWidth;

  /// The cap style of the progress bar. Defaults to square, options include
  /// StrokeCap.round, StrokeCap.square, StrokeCap.butt
  final StrokeCap progressStrokeCap;

  ///the stroke width of the background bar
  final double backgroundStrokeWidth;

  /// The cap style of the progress bar. Defaults to square, options include
  /// StrokeCap.round, StrokeCap.square, StrokeCap.butt
  final StrokeCap backgroundStrokeCap;

  /// The Color of the outer circle of the points given in the points parameter
  /// defaults to Colors.blue
  final Color pointColor;

  /// The Color of the outer circle of the points given in the points parameter
  /// defaults to Colors.white
  final Color pointInnerColor;

  /// The radius of the outer circle of the points given in the points parameter
  /// defaults to 7.5
  final double pointRadius;

  /// The radius of the inner circle of the points given in the points parameter
  /// defaults to 2.5
  final double pointInnerRadius;

  const Progresso(
      {Key? key,
      this.start = 0.0,
      this.progress = 0.0,
      this.progressColor = Colors.blue,
      this.backgroundColor = Colors.grey,
      this.progressStrokeWidth = 10.0,
      this.backgroundStrokeWidth = 5.0,
      this.progressStrokeCap = StrokeCap.butt,
      this.backgroundStrokeCap = StrokeCap.butt,
      this.pointColor = Colors.blue,
      this.pointInnerColor = Colors.white,
      this.pointRadius = 7.5,
      this.pointInnerRadius = 2.5,
      this.points = const []})
      : super(key: key);

  @override
  State<Progresso> createState() => _ProgressoState();
}

class _ProgressoState extends State<Progresso> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: _ProgressoPainter(
            progress: widget.progress,
            start: widget.start,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
            progressStrokeWidth: widget.progressStrokeWidth,
            progressStrokeCap: widget.progressStrokeCap,
            backgroundStrokeWidth: widget.backgroundStrokeWidth,
            backgroundStrokeCap: widget.backgroundStrokeCap,
            pointColor: widget.pointColor,
            pointInnerColor: widget.pointInnerColor,
            pointRadius: widget.pointRadius,
            pointInnerRadius: widget.pointInnerRadius,
            points: widget.points),
        child: const Center());
  }
}

class _ProgressoPainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintProgress = Paint();
  final Paint _paintPoint = Paint();
  final Paint _paintPointCenter = Paint();
  final Color backgroundColor;
  final Color progressColor;
  final double start;
  final double progress;
  final double progressStrokeWidth;
  final StrokeCap progressStrokeCap;
  final double backgroundStrokeWidth;
  final StrokeCap backgroundStrokeCap;
  final Color pointColor;
  final Color pointInnerColor;
  final double pointRadius;
  final double pointInnerRadius;
  final List<double> points;

  _ProgressoPainter(
      {required this.start,
      required this.progress,
      required this.progressColor,
      required this.backgroundColor,
      required this.progressStrokeWidth,
      required this.progressStrokeCap,
      required this.backgroundStrokeWidth,
      required this.backgroundStrokeCap,
      required this.points,
      required this.pointColor,
      required this.pointInnerColor,
      required this.pointInnerRadius,
      required this.pointRadius}) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeCap = backgroundStrokeCap;
    _paintBackground.strokeWidth = backgroundStrokeWidth;
    _paintProgress.color = progressColor;
    _paintProgress.style = PaintingStyle.stroke;
    _paintProgress.strokeCap = progressStrokeCap;
    _paintProgress.strokeWidth = progressStrokeWidth;
    _paintPoint.color = pointColor;
    _paintPoint.style = PaintingStyle.fill;
    _paintPointCenter.color = pointInnerColor;
    _paintPointCenter.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final startOffset = Offset(0.0, size.height / 2);
    final endOffset = Offset(size.width, size.height / 2);
    canvas.drawLine(startOffset, endOffset, _paintBackground);
    final xStart = size.width * start;
    var cappedProgress = progress;
    if (progress > 1) {
      cappedProgress = 1.0;
    }
    var xProgress = size.width * cappedProgress;
    final progressStart = Offset(xStart, size.height / 2);
    canvas.drawLine(
        progressStart, Offset(xProgress, size.height / 2), _paintProgress);
    for (var point in points) {
      var paint = Paint()
        ..color = pointColor
        ..strokeWidth = 2.0;
      var pointPos = size.width * point;
      final pointX0 = Offset(pointPos, 0);
      final pointX1 = Offset(pointPos, size.height);
      canvas.drawLine(pointX0, pointX1, paint);
      //canvas.drawCircle(pointX, pointInnerRadius, _paintPointCenter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as _ProgressoPainter;
    return old.progress != progress ||
        old.start != start ||
        old.progressColor != progressColor ||
        old.backgroundColor != backgroundColor ||
        old.progressStrokeWidth != progressStrokeWidth ||
        old.backgroundStrokeWidth != backgroundStrokeWidth ||
        old.progressStrokeCap != progressStrokeCap ||
        old.backgroundStrokeCap != backgroundStrokeCap ||
        old.pointColor != pointColor ||
        old.pointInnerColor != pointInnerColor ||
        old.pointRadius != pointRadius ||
        old.pointInnerRadius != pointInnerRadius ||
        old.points != points;
  }
}
