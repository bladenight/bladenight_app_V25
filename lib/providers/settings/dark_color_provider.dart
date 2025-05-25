import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'dark_color_provider.g.dart';

@riverpod
class ThemePrimaryDarkColor extends _$ThemePrimaryDarkColor {
  @override
  Color build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.themePrimaryDarkColorKey)
        .listen((event) {
      state = event.value;
    });
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.themePrimaryDarkColor;
  }

  void setColor(Color color) {
    HiveSettingsDB.setThemePrimaryDarkColor(color);
    state = color;
  }
}
