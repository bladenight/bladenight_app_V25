import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'icon_size_provider.g.dart';

@riverpod
class IconSize extends _$IconSize {
  @override
  double build() {
    //this makes provider global
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.iconSizeKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.iconSizeValue;
  }

  double setSize(double value) {
    state = value;
    return value;
  }
}
