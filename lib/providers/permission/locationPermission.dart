import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locationPermission.g.dart';

@riverpod
class AppLocationPermission extends _$AppLocationPermission {
  @override
  build() {
    return Permission;
  }
}
