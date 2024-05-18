import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

part 'geofence_point.mapper.dart';

@MappableClass()
class GeofencePoint with GeofencePointMappable
{
  @MappableField(key: 'lat')
  final double lat;
  @MappableField(key: 'lon')
  final double lon;
  @MappableField(key: 'url')
  final String imageUrl;
  @MappableField(key: 'des')
  final String description;
  late LatLng latLon;

  GeofencePoint(this.lat, this.lon, this.imageUrl,this.description) {
    latLon = LatLng(lat, lon);
  }
}


@MappableClass()
class GeofencePoints with GeofencePointsMappable {
  @MappableField(key: 'gfp')
  final List<GeofencePoint> geofencePoints;
  GeofencePoints(this.geofencePoints);
}