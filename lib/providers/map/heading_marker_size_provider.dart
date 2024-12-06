import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'icon_size_provider.dart';

part 'heading_marker_size_provider.g.dart';

@riverpod
class HeadingMarkerSize extends _$HeadingMarkerSize {
  var size = 20.0;

  @override
  double build() {
    size = ref.watch(iconSizeProvider);
    return size * 2;
  }

  double setSize(double value) {
    print('headingmarker zoom size= $value');
    if (value > 18) {
      state = value * 1.5;
    } else if (value > 15) {
      state = value * 1.4;
    } else if (value > 11) {
      state = value * 1.2;
    } else {
      state = value * 1.0;
    }
    //print('heading_marker_size_provider size $value $state');
    print('headingmarker zoom result size= $state');
    return state * 2;
  }
}
