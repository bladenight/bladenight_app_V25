import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/route.dart';
import '../models/shake_hand_result.dart';

const Color systemPrimaryDefaultColor = Color(0xFF4097EA);
const Color systemPrimaryDarkDefaultColor = Color(0xFFFCF250);
const Color meDefaultColor = Color(0xDD29BE1A);

//Start and finish of Munich Bladenight 48.13175057596983, 11.543880569191229
const double defaultAppLatitude = 48.13250913196827;
const double defaultAppLongitude = 11.543837661522703;
double defaultLatitude = 48.13250913196827;
double defaultLongitude = 11.543837661522703;
final LatLng defaultLatLng = LatLng(defaultLatitude, defaultLongitude);

//TODO Add startpoint to route
String defaultStartPoint =
    'Deutsches Verkehrsmuseum\nSchwanthalerhöhe\nMünchen';
String startPoint = 'Deutsches Verkehrsmuseum\n Schwanthalerhöhe\nMünchen';

const String mainSponsorPlaceholder = 'assets/images/bladenight_logo.png';
const String secondLogoPlaceholder = 'assets/images/skatemunich.png';

//globals
String bladeguardRegisterLink =
    'https://bladenight-muenchen.de/blade-guards/#anmelden';
String bladeguardPrivacyLink = 'https://bladenight-muenchen.de/datenschutz';
String bladeguardLinkText = 'Bladeguard';

String liveMapLink = 'https://bladenight-muenchen.de/bladenight-live-karte/';
String liveMapLinkText = '';

String actualHttpSServerHost = '';
Uri? actualServerAndPortUri;

//Storelinks
String playStoreLink =
    'https://play.google.com/store/apps/details?id=de.bladenight.bladenight_app_flutter';
String iOSAppStoreLink =
    'https://apps.apple.com/de/app/bladenight-vorab/id1629988473';

SharedPreferences? globalSharedPrefs;
ShakeHandResult? shakeHandAppOutdatedResult;
