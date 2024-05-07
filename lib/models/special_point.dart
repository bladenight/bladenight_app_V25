import 'package:dart_mappable/dart_mappable.dart';
import 'package:latlong2/latlong.dart';

part 'special_point.mapper.dart';

@MappableClass()
class SpecialPoint with SpecialPointMappable
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

  SpecialPoint(this.lat, this.lon, this.imageUrl,this.description) {
    latLon = LatLng(lat, lon);
  }
}


@MappableClass()
class SpecialPoints with SpecialPointsMappable {
  @MappableField(key: 'spp')
  final List<SpecialPoint> specialPoints;
  SpecialPoints(this.specialPoints);
}