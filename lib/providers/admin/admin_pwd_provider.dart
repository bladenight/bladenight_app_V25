import 'package:dart_mappable/dart_mappable.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/device_id_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/messages/admin.dart';
import '../../wamp/admin_calls.dart';

part 'admin_pwd_provider.g.dart';

/// Authenticate password against server
///
/// returns
/// - true if ok or
/// - false if fails
@riverpod
class AdminPasswordCheck extends _$AdminPasswordCheck {
  @override
  FutureOr<bool> build() async {
    return false;
  }

  FutureOr<bool> login(String password) async {
    if (password.isNotEmpty) {
      state = AsyncLoading();
      var res = await AdminCalls.verifyAdminPassword(MapperContainer.globals
          .toMap(AdminMessage.authenticate(
              password: password, deviceId: DeviceId.appId)));
      if (res == 'OK') {
        await ref.read(adminPwdProvider.notifier).setPassword(password);
        state = AsyncValue.data(true);
        return true;
      }
      await ref.read(adminPwdProvider.notifier).removePassword();
      state = AsyncData(false);
    }
    state = AsyncData(false);
    return false;
  }
}

/// Check if a valid server password is saved
@riverpod
class AdminPwdSet extends _$AdminPwdSet {
  @override
  bool build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.serverPasswordKey)
        .listen((event) => state = event.value != null);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.serverPassword != null;
  }
}

/// Get or Set local server password
///
/// - returns the server password
/// - can be [null]
///
/// ``` dart
/// var password = ref.read(adminPwdProvider);
/// ```
///
/// Set new password
/// ``` dart
/// await ref.read(adminPwdProvider.notifier).setPassword(password);
/// ```
///
/// Remove password from app
/// ```dart
/// await ref.read(adminPwdProvider.notifier).removePassword();
/// ```
@riverpod
class AdminPwd extends _$AdminPwd {
  @override
  String? build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: HiveSettingsDB.serverPasswordKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return HiveSettingsDB.serverPassword;
  }

  Future<void> setPassword(String? password) {
    return HiveSettingsDB.setServerPassword(password);
  }

  Future<void> removePassword() {
    return HiveSettingsDB.setServerPassword(null);
  }
}
