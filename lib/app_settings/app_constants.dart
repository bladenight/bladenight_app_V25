import 'dart:ui';

const String hiveBoxSettingDbName = 'settings';
const String hiveBoxLocationDbName = 'locationTrkDb';
const String hiveBoxLoggingDbName = 'logBox';
const String hiveBoxServerConfigDBName = 'appServerConfigDb';
const String fmtcTileStoreName = 'fmtcTileStore';

///factor to resize icons with MediaQuery (MediaQuery.of(context).size.width * mediaSizePercentage)
double mediaSizePercentage = 0.05;
double mediaSizeTrackProgressIconsPercentage = 0.03;

///Default update interval to get [RealtimeData] when not tracking in milliseconds
const int defaultRealtimeUpdateInterval = 15000;

///Default update interval to get [RealtimeData] when tracking in milliseconds
const int defaultLocationUpdateInterval = 5000;

const Duration wampTimeout = Duration(seconds: 10);

///Default minimum running interval in minutes before auto stop.
///Issue can occur when user goes around finish on startup and tracking is switched on
const int defaultMinimumDurationBeforeAutoStopInMin = 60;
const int defaultMinPreOnsiteLogin = 180;

///Maximum duration in Server in milli sec bnserver.relationships.collector.maxage=3600000
const int maxDurationCodeIsValid = 3600000; //1hour

const double primaryContrastingAlpha = 0.3;

///Intend for list tiles and divider
const double tileIntend = 16.0;

class ColorConstants {
  static const List<Color> friendPickerColors = [
    ...colors1,
    ...colors2,
    ...colors3
  ];

  static const List<Color> colors1 = [
    Color(0xFFEEEEEE),
    Color(0xFF737373),
    Color(0xFFFCF250), //defult skatemunixh
    Color(0xFF4097EA),
    Color(0xFF70C04F),
    Color(0xFFFC8D33),
    Color(0xFFED4A57),
    Color(0xFFD1086A),
    Color(0xFFA208BA),
  ];
  static const List<Color> colors2 = [
    Color(0xFFED0014),
    Color(0xFFEC858E),
    Color(0xFFFFD3D4),
    Color(0xFFFEDBB3),
    Color(0xFFFFC482),
    Color(0xFFD29046),
    Color(0xFF99643A),
    Color(0xFF2F6D4E),
    Color(0xFF1C4928),
  ];
  static const List<Color> colors3 = [
    Color(0xFF3897F1),
    Color(0xFF5997A1),
    Color(0xFFFFFFFF),
    Color(0x00000000),
    Color(0xFFA9DA53),
    Color(0xFFF5C106),
    Color(0xFF485864),
    Color(0xFF940202),
    Color(0xFFB900F1),
  ];

  static const List<Color> colorsGradient = [
    Color(0xFFED8E00),
    Color(0xFFECC385),
    Color(0xFFD3FFD5),
    Color(0xFFB3EAFE),
    Color(0xFF82CFFF),
    Color(0xFF467ED2),
  ];
}
