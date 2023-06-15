extension DistanceString on int? {
  String formatDistance() {
    int meters = this ?? 0;
    String s = '';
    if (meters.abs() == 0) {
      return s;
    } else if (meters.abs() < 1000) {
      s = '$meters m';
    } else {
      double km = meters / 1000.0;
      s = '${km.toStringAsFixed(1)} km';
    }
    return s;
  }
}

///Format [double] to SpeedString in m/s given
///if -1 return 0
///Returns [String] with km/h suffix
extension SpeedString on double? {
  String formatSpeedMPerSec() {
    double speed = this ?? -1;
    String s = '0 km/h';
    if (speed == -1 || speed.abs() == 0) {
      return s;
    } else {
      var speedInkKmH = speed * 60 * 60 / 1000;
      s = '${speedInkKmH.toStringAsFixed(1)} km/h';
    }
    return s;
  }

  String formatSpeedKmH() {
    double speed = this ?? -1;
    String s = '0.0 km/h';
    if (speed < 0 || speed.abs() == 0) {
      return s;
    } else {
      s = '${speed.toStringAsFixed(1)} km/h';
    }
    return s;
  }
}
