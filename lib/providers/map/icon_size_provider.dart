import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';

part 'icon_size_provider.g.dart';

@riverpod
class IconSize extends _$IconSize {

  @override
  double build() {
    //this makes provider global
    Hive.box('settings')
        .watch(key: HiveSettingsDB.iconSizeKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.iconSizeValue;
  }

  double setSize(double value) {
    state = value;
    return value;
  }
}
