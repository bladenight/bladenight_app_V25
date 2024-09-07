import 'dart:collection';

import 'package:flutter_launcher_icons/custom_exceptions.dart';

class AverageList<T> extends ListBase<T> {
  List<T> innerList = [];
  final int maxLength;

  AverageList({required this.maxLength});

  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, T value) {
    innerList[index] = value;
  }

  @override
  T operator [](int index) => innerList[index];

  @override
  void add(T element) {
    if (innerList.length < maxLength) {
      innerList.add(element);
    } else {
      innerList.removeLast();
      innerList.insert(0, element);
    }
  }

  T getAverage() {
    Type type = T;
    if (type == double) {
      if (innerList.isEmpty) return 0.0 as T;
      double res = 0.0;
      for (int i = 0; i < innerList.length; i++) {
        res += innerList[i] as double;
      }
      return res / innerList.length as T;
    }
    if (type == int) {
      if (innerList.isEmpty) return 0 as T;
      int res = 0;
      for (int i = 0; i < innerList.length; i++) {
        res += innerList[i] as int;
      }
      return (res / innerList.length).round() as T;
    }
    throw const InvalidConfigException('only double and int');
  }
}
