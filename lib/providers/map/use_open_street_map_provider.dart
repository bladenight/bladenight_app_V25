import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'use_open_street_map_provider.g.dart';

@riverpod
class UseOpenStreetMap extends _$UseOpenStreetMap {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: MapSettings.openStreetMapEnabledKey)
        .listen((event) => state = event.value);
    return MapSettings.openStreetMapEnabled;
  }
}
