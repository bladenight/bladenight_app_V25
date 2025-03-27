import 'dart:math';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../app_settings/app_constants.dart';

class ColorMapper extends SimpleMapper<Color> {
  const ColorMapper();

  @override
  Color decode(dynamic value) {
    return Color(int.parse('ff${value.toString().substring(1)}', radix: 16));
  }

  @override
  dynamic encode(Color self) {
    return "#${(self.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}";
  }
}

extension ColorString on Color {
  String toHexString() {
    return MapperContainer.globals.toValue(this) as String;
  }
}

Color getRandomColor() {
  var amount = ColorConstants.friendPickerColors.length;
  return ColorConstants.friendPickerColors[Random().nextInt(amount - 1)];
}

extension StringColor on String? {
  Color toColor() {
    try {
      return MapperContainer.globals.fromValue(this);
    } catch (e) {
      return Colors.limeAccent;
    }
  }
}
