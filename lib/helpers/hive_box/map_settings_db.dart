part of 'hive_settings_db.dart';

extension MapSettings on HiveSettingsDB {
  ///minZoom for Static map tiles
  static double get minZoomDefault {
    return 2.0;
  }

  ///maxZoom for Static map tiles
  static double get maxZoomDefault {
    return 20.0;
  }

  ///minZoom for Static map tiles
  static int get minNativeZoomDefault {
    return 5;
  }

  ///maxZoom for Static map tiles
  static int get maxNativeZoomDefault {
    return 18;
  }

  static const String _minZoomKey = 'minZoomPref_1Key';

  ///get minZoom level for online map
  static double get minZoom {
    return HiveSettingsDB._hiveBox.get(_minZoomKey, defaultValue: 5.0);
  }

  ///set minZoom level for online map
  static void setMinZoom(double val) {
    HiveSettingsDB._hiveBox.put(_minZoomKey, val);
  }

  static const String _maxZoomKey = 'maximumZoomPrefKey4';

  ///get maxZoom level for map
  static double get maxZoom {
    return HiveSettingsDB._hiveBox
        .get(_maxZoomKey, defaultValue: 19.0); //osm max 19
  }

  ///set maxZoom level for map
  static void setMaxZoom(double val) {
    HiveSettingsDB._hiveBox.put(_maxZoomKey, val);
  }

  static const String _minNativeZoomKey = 'minimumNativeZoomPref';

  ///get minNativeZoom level for map
  static int get minNativeZoom {
    return HiveSettingsDB._hiveBox.get(_minNativeZoomKey, defaultValue: 5);
  }

  ///set minNativeZoom level for map
  static void setMinNativeZoom(int val) {
    HiveSettingsDB._hiveBox.put(_minNativeZoomKey, val);
  }

  static const String _maxNativeZoomKey = 'maximumNativeZoomPref5';

  ///get maxNativeZoom level for map - native zoom must smaller or equal max possible maxZoom
  static int get maxNativeZoom {
    return HiveSettingsDB._hiveBox.get(_maxNativeZoomKey, defaultValue: 18);
  }

  ///set maxNativeZoom level for map
  static void setMaxNativeZoom(int val) {
    HiveSettingsDB._hiveBox.put(_maxNativeZoomKey, val);
  }

  ///Returns map boundaries for static asset offline map tiles
  static LatLngBounds get mapOfflineBoundaries {
    return LatLngBounds(
      const LatLng(kIsWeb ? 47.9579 : 48.0570, kIsWeb ? 11.8213 : 11.4416),
      const LatLng(48.2349, kIsWeb ? 11.2816 : 11.6213),
    );
  }

  static LatLngBounds get bayernAtlasBoundaries {
    //<ows:LowerCorner>8.945107890491915 47.248466288051446</ows:LowerCorner>
    // <ows:UpperCorner>13.90891310401004 50.57987000589413</ows:UpperCorner>
    return LatLngBounds(
      const LatLng(47.248466288051446, 8.945107890491915),
      const LatLng(50.57987000589413, 13.90891310401004),
    );
  }

  ///Returns map boundaries for static asset offline map tiles
  static LatLngBounds get mapOnlineDefaultBoundaries {
    return LatLngBounds(
      const LatLng(81.47299, 46.75348),
      const LatLng(29.735139, -34.49296),
    );
  }

  static const String _mapOnlineBoundariesKey = 'mapOnlineBoundariesKeyPref';

  ///Returns map boundaries for Online map like Openstreetmap
  ///were served
  ///
  /// Returns [mapOnlineDefaultBoundaries] if no parameters given or failed
  static LatLngBounds get mapOnlineBoundaries {
    var val = HiveSettingsDB._hiveBox
        .get(_mapOnlineBoundariesKey, defaultValue: null);

    try {
      if (val == null) {
        return mapOnlineDefaultBoundaries;
      }
      var boundValues = (val as String).split(',');
      if (boundValues.length != 4) {
        return mapOnlineDefaultBoundaries;
      }
      return LatLngBounds(
        LatLng(double.parse(boundValues[0]), double.parse(boundValues[1])),
        LatLng(double.parse(boundValues[2]), double.parse(boundValues[3])),
      );
    } catch (e) {
      BnLog.error(text: 'LatLngBounds could not converted', exception: e);
    }
    return mapOnlineDefaultBoundaries;
  }

  ///set mapBoundariesString
  static void setMapBoundaries(String val) {
    HiveSettingsDB._hiveBox.put(_mapOnlineBoundariesKey, val);
  }

  static void removeMapBoundaries() {
    HiveSettingsDB._hiveBox.delete(_mapOnlineBoundariesKey);
  }

  static const String _openStreetMapLinkKey = 'osmLightLinkPref';

  ///get openStreetMapLinkAsString
  static String get openStreetMapLinkString {
    return HiveSettingsDB._hiveBox.get(_openStreetMapLinkKey,
        defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
  }

  static const String _bayernAtlasLinkKey = 'byAtlasLightLinkPref';

  ///get openStreetMapLinkAsString
  static String get bayernAtlasLinkString {
    return HiveSettingsDB._hiveBox.get(_bayernAtlasLinkKey,
        defaultValue:
            'https://wmtsod1.bayernwolke.de/wmts/by_webkarte/smerc/{z}/{x}/{y}');
  }

  ///set openStreetMapLinkString
  static void setOpenStreetMapLink(String val) {
    HiveSettingsDB._hiveBox.put(_openStreetMapLinkKey, val);
  }

  static void removeOpenStreetMapLink() {
    HiveSettingsDB._hiveBox.delete(_openStreetMapLinkKey);
  }

  static const String _openStreetMapDarkLinkKey = 'osmDarkLinkPref';

  ///get openStreetMapDarkLinkAsString
  static String get openStreetMapDarkLinkString {
    return HiveSettingsDB._hiveBox.get(_openStreetMapDarkLinkKey,
        defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
  }

  ///set openStreetMapDarkLinkString
  static void setOpenStreetMapDarkLink(String val) {
    HiveSettingsDB._hiveBox.put(_openStreetMapDarkLinkKey, val);
  }

  static void removeOpenStreetMapDarkLink() {
    HiveSettingsDB._hiveBox.delete(_openStreetMapDarkLinkKey);
  }

  static const String mapMenuVisibleKey = 'mapMenuVisiblePref';

  ///get mapMenuVisible
  static bool get mapMenuVisible {
    return HiveSettingsDB._hiveBox.get(mapMenuVisibleKey, defaultValue: false);
  }

  ///set mapMenuVisibleString
  static void setMapMenuVisible(bool val) {
    HiveSettingsDB._hiveBox.put(mapMenuVisibleKey, val);
  }

  static const String compassVisibleKey = 'compassVisiblePref';

  ///get compassVisible
  static bool get compassVisible {
    return HiveSettingsDB._hiveBox.get(compassVisibleKey, defaultValue: true);
  }

  ///set compassVisibleString
  static void setCompassVisible(bool val) {
    HiveSettingsDB._hiveBox.put(compassVisibleKey, val);
  }

  static const String eventDetailsVisibleKey = 'eventDetailsVisiblePref';

  /// get eventDetailsVisible
  /// show details of event in map overlay if event is running
  static bool get eventDetailsVisible {
    return HiveSettingsDB._hiveBox
        .get(eventDetailsVisibleKey, defaultValue: true);
  }

  ///set eventDetailsVisibleString
  static void setEventDetailsVisible(bool val) {
    HiveSettingsDB._hiveBox.put(eventDetailsVisibleKey, val);
  }

  static const String showOwnTrackKey = 'showOwnTrackPref';

  /// Get value
  /// if own driven track should bei shown on map
  static bool get showOwnTrack {
    return HiveSettingsDB._hiveBox.get(showOwnTrackKey, defaultValue: true);
  }

  ///set showOwnTrack
  static Future<void> setShowOwnTrack(bool val) async {
    return HiveSettingsDB._hiveBox.put(showOwnTrackKey, val);
  }

  static const String showOwnColoredTrackKey = 'showOwnColoredTrackPref';

  /// Get value
  /// if own driven track should bei shown on map
  static bool get showOwnColoredTrack {
    return HiveSettingsDB._hiveBox
        .get(showOwnColoredTrackKey, defaultValue: false);
  }

  ///set showOwnColoredTrack
  static Future<void> setShowOwnColoredTrack(bool val) {
    return HiveSettingsDB._hiveBox.put(showOwnColoredTrackKey, val);
  }

  static const String cameraFollowKey = 'cameraFollowPref';

  /// Get last camera setting (global)
  static CameraFollow get cameraFollow {
    var value = HiveSettingsDB._hiveBox.get(cameraFollowKey, defaultValue: 0);
    return CameraFollow.values.where((element) => element.index == value).first;
  }

  ///set cameraFollow
  static void setCameraFollow(CameraFollow val) {
    HiveSettingsDB._hiveBox.put(cameraFollowKey, val.index);
  }

  static const String alignFlutterMapKey = 'alignStreetMapPref';

  /// Get last camera setting (global)
  static AlignFlutterMapState get alignFlutterMap {
    var value =
        HiveSettingsDB._hiveBox.get(alignFlutterMapKey, defaultValue: 0);
    return AlignFlutterMapState.values
        .where((element) => element.index == value)
        .first;
  }

  ///set alignStreetMap
  static void setAlignFlutterMap(AlignFlutterMapState val) {
    HiveSettingsDB._hiveBox.put(alignFlutterMapKey, val.index);
  }

  static const String openStreetMapEnabledKey = 'openStreetMapEnabledPref';

  ///get openStreetMapEnabled
  static bool get openStreetMapEnabled {
    return HiveSettingsDB._hiveBox
        .get(openStreetMapEnabledKey, defaultValue: false);
  }

  ///show openStreetMap setOpenStreetMapEnable
  static void setOpenStreetMapEnabled(bool val) {
    HiveSettingsDB._hiveBox.put(openStreetMapEnabledKey, val);
  }

  static const String wasOpenStreetMapEnabledFlagKey =
      'wasOpenStreetMapEnabledFlagPref';

  ///get flag for tracking to deactivate OSM after stop
  static bool get wasOpenStreetMapEnabledFlag {
    return HiveSettingsDB._hiveBox
        .get(wasOpenStreetMapEnabledFlagKey, defaultValue: false);
  }

  ///set flag for tracking to deactivate OSM after stop
  static void setWasOpenStreetMapEnabledFlag(bool val) {
    HiveSettingsDB._hiveBox.put(wasOpenStreetMapEnabledFlagKey, val);
  }

  static const String _polylineTrackPointsAmountKey =
      'polylineTrackPointsAmountPref_1Key';

  ///get polylineTrackPointsAmount level for online map
  static int get polylineTrackPointsAmount {
    return HiveSettingsDB._hiveBox
        .get(_polylineTrackPointsAmountKey, defaultValue: 1000);
  }

  ///set polylineTrackPointsAmount for online for drawn poly lines while tracking
  static void setPolylineTrackPointsAmount(int val) {
    HiveSettingsDB._hiveBox.put(_polylineTrackPointsAmountKey, val);
  }
}
