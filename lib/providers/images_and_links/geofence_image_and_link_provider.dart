import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger/logger.dart';
import '../../models/geofence_point.dart';
import '../../models/image_and_link.dart';

part 'geofence_image_and_link_provider.g.dart';

String geofenceImageAndLinkKey = 'geofenceLocIalDbKey';
ImageAndLink _defaultGeofence = ImageAndLink(
    '',
    '',
    '{"gfp":['
        '{"lat":48.131092,"lon":11.542514,"des":"central","id":1,"radius":400.0},'
        '{"lat":48.132384,"lon":11.539843,"des":"left","id":2,"radius":400.0},'
        '{"lat":48.133737,"lon":11.541330,"des":"subway","id":3,"radius":400.0},'
        '{"lat":48.132381,"lon":11.545835,"des":"rechts Zahnradbahn","id":4,"radius":400.0}'
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
    HiveSettingsDB.settingsHiveBox.put(geofenceImageAndLinkKey, imageAndLink);
  }
}

@riverpod
class GeofencePoints extends _$GeofencePoints {
  @override
  Future<List<GeofencePoint>> build() async {
    List<GeofencePoint> points = [];
    var pointsJson = ref.read(geofenceImageAndLinkProvider).text;
    if (pointsJson != null) {
      try {
        var spPoints = GeofencePointsMapper.fromJson(pointsJson);
        points = spPoints.geofencePoints;
      } catch (e) {
        BnLog.error(
            text: 'GeofencePoints parse error $e', className: toString());
      }
    }
    return points;
  }
}
