import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';

part 'app_outdated_provider.g.dart';


@riverpod
class AppOutdated extends _$AppOutdated {
  @override
  bool build() {
    //listen to global settings value
    Hive.box('settings').watch(key: HiveSettingsDB.appOutDatedKey).listen(
            (event) =>  state = event.value
    );
    return HiveSettingsDB.appOutDated;
  }

  update(bool isOutdated) {
    HiveSettingsDB.setAppOutDated(isOutdated);
    state = isOutdated;
  }
}
