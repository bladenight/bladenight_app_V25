import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heading_marker_size_provider.g.dart';

@riverpod
class HeadingMarkerSize extends _$HeadingMarkerSize {
  @override
  double build() {
    return 20;
  }

  double setSize(double value) {
    if (value > 18) {
      state = value * 2;
    }
    else if (value > 15) {
      state = value * 1.5;
    } else {
      state = value;
    }
    return value;
  }
}
