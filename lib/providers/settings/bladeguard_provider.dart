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
      HiveSettingsDB.setIsSpecialTail(false);
      HiveSettingsDB.setIsSpecialHead(false);
      HiveSettingsDB.setWantSeeFullOfProcession(false);
      HiveSettingsDB.setSpecialRightsPrefs(false);
      HiveSettingsDB.setIsBladeGuard(false);
      HiveSettingsDB.setOneSignalRegisterBladeGuardPush(false);
      OnesignalHandler.registerPushAsBladeGuard(false,'');
      state = value;
      return;
    }
    HiveSettingsDB.setIsBladeGuard(value);
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
        .watch(key: HiveSettingsDB.isBladeguardEmailValidKey )
        .listen((event) => state = event.value);
    return validateEmail(HiveSettingsDB.bladeguardEmail);
  }
}
