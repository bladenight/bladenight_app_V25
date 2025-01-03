import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/validator.dart';

part 'bladeguard_provider.g.dart';

@riverpod
class UserIsBladeguard extends _$UserIsBladeguard {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.isBladeGuardKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.isBladeGuard;
  }

  void setValue(bool value) {
    if (value == false) {
      //switch off and unregister
      HiveSettingsDB.setBgSettingVisible(false);
      HiveSettingsDB.setBgLeaderSettingVisible(false);
      OnesignalHandler.registerPushAsBladeGuard(false, '');
      state = value;
      return;
    }
    HiveSettingsDB.setIsBladeGuard(value);
  }
}

@riverpod
class UserIsAdmin extends _$UserIsAdmin {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.bgIsAdmin)
        .listen((event) => state = event.value);
    return HiveSettingsDB.bgIsAdmin;
  }

  void setValue(bool value) {
    HiveSettingsDB.setBgIsAdmin(value);
  }
}

@riverpod
class BladeguardSettingsVisible extends _$BladeguardSettingsVisible {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.bgSettingVisibleKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.bgSettingVisible;
  }

  void setValue(bool value) {
    HiveSettingsDB.setBgSettingVisible(value);
  }
}

@riverpod
class IsValidBladeGuardEmail extends _$IsValidBladeGuardEmail {
  @override
  bool build() {
    Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.isBladeguardEmailValidKey)
        .listen((event) => state = event.value);
    return validateEmail(HiveSettingsDB.bladeguardEmail);
  }
}
