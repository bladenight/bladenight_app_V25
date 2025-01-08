import 'package:flutter/cupertino.dart';

class InfoClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 12;
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
    return false;
  }
}
