import 'package:flutter/material.dart';

class SpeedToColor {
  static Color getColorFromSpeed(double speed) {
    if (speed <= 0) return Colors.blue;
    if (speed <= 1) return Colors.blueAccent;
    if (speed <= 2) return Colors.green.shade100;
    if (speed <= 3) return Colors.green.shade200;
    if (speed <= 4) return Colors.green.shade300;
    if (speed <= 5) return Colors.yellow.shade100;
    if (speed <= 6) return Colors.yellow.shade200;
    if (speed <= 7) return Colors.yellow.shade300;
    if (speed <= 8) return Colors.yellow.shade400;
    if (speed <= 9) return Colors.yellow.shade400;

    if (speed <= 10) return Colors.purple.shade100;
    if (speed <= 12) return Colors.purple.shade200;
    if (speed <= 14) return Colors.purple.shade300;
    if (speed <= 16) return Colors.purple.shade400;
    if (speed <= 18) return Colors.purple.shade500;

    if (speed <= 20) return Colors.red.shade100;
    if (speed <= 22) return Colors.red.shade200;
    if (speed <= 24) return Colors.red.shade300;
    if (speed <= 26) return Colors.red.shade400;
    if (speed <= 28) return Colors.red.shade600;
    if (speed <= 30) return Colors.red.shade700;
    if (speed <= 35) return Colors.red.shade800;
    return Colors.red.shade900;
  }

  static List<Color> speedColors = [
    Colors.blue,
    Colors.blueAccent,
    Colors.green.shade100,
    Colors.green.shade200,
    Colors.green.shade300,
    Colors.yellow.shade100,
    Colors.yellow.shade200,
    Colors.yellow.shade300,
    Colors.yellow.shade400,
    Colors.yellow.shade400,
    Colors.purple.shade100,
    Colors.purple.shade200,
    Colors.purple.shade300,
    Colors.purple.shade400,
    Colors.purple.shade500,
    Colors.red.shade100,
    Colors.red.shade200,
    Colors.red.shade300,
    Colors.red.shade400,
    Colors.red.shade600,
    Colors.red.shade700,
    Colors.red.shade800,
    Colors.grey.shade800
  ];
}
