import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:latlong2/latlong.dart';

part 'geofence_point.mapper.dart';

@MappableClass()
class GeofencePoint with GeofencePointMappable {
  @MappableField(key: 'lat')
  final double lat;
  @MappableField(key: 'lon')
  final double lon;
  @MappableField(key: 'des')
  final String description;
  @MappableField(key: 'id')
  final String id;

  ///Radius
  @MappableField(key: 'rad')
  final double radius;

  ///notifyOnEntry
  @MappableField(key: 'nen')
  final bool notifyOnEntry;

  ///notifyOnExit
  @MappableField(key: 'nex')
  final bool notifyOnExit;

  ///notifyOnDwell
  @MappableField(key: 'ndw')
  final bool notifyOnDwell;

  late LatLng latLon;

  GeofencePoint(
    this.lat,
    this.lon,
    this.description,
    this.id, {
    this.radius = 200.0,
    this.notifyOnEntry = false,
    this.notifyOnExit = false,
    this.notifyOnDwell = true,
  }) {
    latLon = LatLng(lat, lon);
  }
}

@MappableClass()
class GeofencePoints with GeofencePointsMappable {
  @MappableField(key: 'gfp')
  final List<GeofencePoint> geofencePoints;

  GeofencePoints(this.geofencePoints);

  static List<Geofence> getGeofenceList(geofencePoints) {
    List<Geofence> list = [];
    for (var geofence in geofencePoints) {
      list.add(Geofence(
          identifier: geofence.id,
          radius: geofence.radius,
          latitude: geofence.lat,
          longitude: geofence.lon,
          notifyOnEntry: geofence.notifyOnEntry,
          notifyOnExit: geofence.notifyOnExit,
          notifyOnDwell: geofence.notifyOnDwell,
          loiteringDelay: 10000));
    }
    return list;
  }
}
