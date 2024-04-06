import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';

part 'special_procession_function_provider.g.dart';

@riverpod
class IsProcessionHead extends _$IsProcessionHead {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.isHeadOfProcessionKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.isHeadOfProcession;
  }
}

@riverpod
class IsProcessionTail extends _$IsProcessionTail {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.isTailOfProcessionKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.isTailOfProcession;
  }
}

@riverpod
class WantSeeFullProcession extends _$WantSeeFullProcession {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.wantSeeFullOfProcessionKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.wantSeeFullOfProcession;
  }
}
