import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';

part 'map_button_visibility_provider.g.dart';

@riverpod
class MapMenuVisible extends _$MapMenuVisible {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: MapSettings.mapMenuVisibleKey)
        .listen((event) => state = event.value);
    return MapSettings.mapMenuVisible;
  }
}
