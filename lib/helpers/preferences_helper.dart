import 'package:shared_preferences/shared_preferences.dart';
import 'logger/logger.dart';

class PreferencesHelper {
  /// Written in headlessTask
  static Future<String?> getLastGeoFenceResult() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('geofenceHeadlessResult');
    } catch (e) {
      BnLog.error(text: 'Error getLastGeoFenceResult', exception: e);
    }
    return null;
  }

  static Future<bool> setLastGeoFenceResult(String string) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString('geofenceHeadlessResult', string);
    } catch (e) {
      BnLog.error(text: 'Error getLastGeoFenceResult', exception: e);
    }
    return true;
  }
}
