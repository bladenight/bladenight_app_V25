import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';

part 'user_trackpoint.mapper.dart';

@MappableClass()
class UserTrackPoint with UserTrackPointMappable {
  UserTrackPoint(this.latitude, this.longitude, this.realSpeedKmh, this.heading,
      this.altitude, this.odometer, this.timeStamp);

  final double latitude;
  final double longitude;
  final double realSpeedKmh;
  final double heading;
  final double altitude;
  final double odometer;
  final DateTime timeStamp;

  String toXML() {
    final f = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return '\t\t<trkpt lat="$latitude" lon="$longitude">\n'
        '\t\t\t<ele>${altitude.toStringAsFixed(2)}</ele>\n'
        '\t\t\t<speed>${realSpeedKmh.toStringAsFixed(1)}</speed>\n'
        '\t\t\t<heading>${heading == -1.0 ? 0.0 : heading.toStringAsFixed(2)}</heading>\n'
        '\t\t\t<odometer>${odometer.toStringAsFixed(2)}</odometer>\n'
        '\t\t\t<time>${f.format(timeStamp.toUtc())}Z</time>\n'
        '\t\t</trkpt>\n';
  }
}

@MappableClass()
class UserTrackPoints with UserTrackPointsMappable {
  UserTrackPoints(this.utps);

  final List<UserTrackPoint> utps;

  //String toJson() => jsonEncode(utps);
  String toXML() {
    var str = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'
        '<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1" creator="BladenightAPP"'
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
        'xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">'
        '<trk>\n'
        '\t<name>Bladenight Aufzeichnung vom ${DateTime.now().toIso8601String()}</name>\n'
        '\t\t<trkseg>\n';
    for (var tp in utps) {
      str = '$str${tp.toXML()}';
    }
    str = '$str\t\t</trkseg>\n'
        '\t</trk>\n'
        '</gpx>\n';
    return str;
  }
}
