import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';

part 'app_outdated_provider.g.dart';

@riverpod
class AppOutdated extends _$AppOutdated {
  @override
  bool build() {
    //listen to global settings value
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.appOutDatedKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.appOutDated;
  }

  update(bool isOutdated) {
    HiveSettingsDB.setAppOutDated(isOutdated);
    state = isOutdated;
  }
}
