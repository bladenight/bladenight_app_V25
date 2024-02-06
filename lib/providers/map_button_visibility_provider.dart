import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';

part 'map_button_visibility_provider.g.dart';

@riverpod
class MapSettingsProvider extends _$MapSettingsProvider {
  @override
  bool build() {
    Hive.box('settings')
        .watch(key: MapSettings.mapMenuVisibleKey)
        .listen((event) => state = event.value);
    return MapSettings.mapMenuVisible;
  }
}
