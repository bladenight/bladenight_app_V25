import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_settings/app_constants.dart';
import '../helpers/hive_box/hive_settings_db.dart';

part 'server_version_provider.g.dart';

@riverpod
class ServerVersion extends _$ServerVersion {
  @override
  String build() {
    //listen to global settings value
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.serverVersionKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.getServerVersion;
  }
}
