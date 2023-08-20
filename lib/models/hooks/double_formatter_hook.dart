import 'dart:ffi';

import 'package:dart_mappable/dart_mappable.dart';

class DoubleFormatterHook extends MappingHook {
  const DoubleFormatterHook();

  @override
  Object? afterEncode(Object? value) {
    if (value is double) {
      return value;//.toStringAsFixed(2);
    }
    return value;
  }
}