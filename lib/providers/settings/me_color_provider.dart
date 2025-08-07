import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'me_color_provider.g.dart';

@riverpod
class MeColor extends _$MeColor {
  @override
  Color build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.meColorKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.meColor;
  }

  void setColor(Color color) {
    HiveSettingsDB.setMeColor(color);
  }
}
