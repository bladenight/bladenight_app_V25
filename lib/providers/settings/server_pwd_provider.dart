import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'server_pwd_provider.g.dart';

@riverpod
class ServerPwdSet extends _$ServerPwdSet {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.serverPasswordKey)
        .listen((event) => state = event.value != null);
    return HiveSettingsDB.serverPassword != null;
  }
}
