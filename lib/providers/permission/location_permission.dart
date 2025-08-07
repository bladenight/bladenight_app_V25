import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/location_permission_dialogs.dart';

part 'location_permission.g.dart';

@riverpod
class AppLocationPermission extends _$AppLocationPermission {
  @override
  Future<LocationPermissionStatus> build(BuildContext context) async {
    return LocationPermissionDialog().getLocationPermissions(context);
  }
}
