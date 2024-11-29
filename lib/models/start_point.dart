import '../app_settings/app_configuration_helper.dart';
import 'images_and_links.dart';

///LocationPoint ist a described [Location]
///
/// - [startPoint] Description of the Point
/// - [startLatLng] as [LatLng] coordinates  of the [LocationPoint]
class LocationPoint {
  String startPoint = '';
  LatLng? startLatLng;

  LocationPoint(this.startPoint, this.startLatLng);
}
