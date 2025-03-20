import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/hive_box/hive_settings_db.dart';

part 'server_version_provider.g.dart';

@riverpod
class ServerVersion extends _$ServerVersion {
  @override
  String build() {
    //listen to global settings value
    Hive.box('settings')
        .watch(key: HiveSettingsDB.serverVersionKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.getServerVersion;
  }
}
