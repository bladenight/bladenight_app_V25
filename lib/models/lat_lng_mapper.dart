import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

import '../app_settings/app_configuration_helper.dart';

class LatLngMapper extends SimpleMapper<LatLng> {
  const LatLngMapper();

  @override
  LatLng decode(value) {
    var map = value as Map<String, dynamic>;
    if (map['lat'] == null && map['lon'] == null) {
      var mapLa = map['la'] ?? defaultLatitude;
      var mapLo = map['lo'] ?? defaultLongitude;
      return LatLng(mapLa, mapLo);
    }
    var mapLa = map['lat'] ?? defaultLatitude;
    var mapLo = map['lon'] ?? defaultLongitude;
    return LatLng(mapLa, mapLo);
  }

  @override
  encode(LatLng self) {
    return {'la': self.latitude, 'lo': self.longitude};
  }
}
