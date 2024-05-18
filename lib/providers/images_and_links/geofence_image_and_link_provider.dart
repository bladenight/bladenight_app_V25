import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/image_and_link.dart';

part 'geofence_image_and_link_provider.g.dart';

String geofenceImageAndLinkKey = 'geofenceIalDbKey';
ImageAndLink _defaultGeofence = ImageAndLink(
    '',
    '',
    '{"gfp":['
        '{"lat":48.131092,"lon":11.542514,"url":"","des":"central"},'
        '{"lat":48.132384,"lon":11.539843,"url":"","des":"left"},'
        '{"lat":48.133737,"lon":11.541330,"url":"","des":"subway"}'
        '{"lat":48.132381,"lon":11.545835,"url":"","des":"rechts Zahnradbahn"}'
        ']'
        '}',
    'geofence');

@riverpod
class GeofenceImageAndLink extends _$GeofenceImageAndLink {
  @override
  ImageAndLink build() {
    HiveSettingsDB.settingsHiveBox
        .watch(key: geofenceImageAndLinkKey)
        .listen((event) => state = event.value);
    return HiveSettingsDB.settingsHiveBox
        .get(geofenceImageAndLinkKey, defaultValue: _defaultGeofence);
  }

  void setValue(ImageAndLink imageAndLink) {
    HiveSettingsDB.settingsHiveBox
        .put(geofenceImageAndLinkKey, imageAndLink);
  }
}
