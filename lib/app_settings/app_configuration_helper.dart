import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/route.dart';
import '../models/shake_hand_result.dart';

const Color systemPrimaryDefaultColor = Color(0xFF0028FF);
const Color systemPrimaryDarkDefaultColor = Color(0xFFFFD700);
const Color meDefaultColor = Color(0xDD29BE1A);

//Start and finish of Munich Bladenight 48.13175057596983, 11.543880569191229
const double defaultAppLatitude = 48.13250913196827;
const double defaultAppLongitude = 11.543837661522703;
double defaultLatitude = 48.13250913196827;
double defaultLongitude = 11.543837661522703;
final LatLng defaultLatLng = LatLng(defaultLatitude, defaultLongitude);
const double defaultInitialZoom = 12.5;

///Bounds for flutter map if no polyline is available
final LatLngBounds defaultMapCamBounds =
    LatLngBounds(LatLng(48.10203, 11.513965), LatLng(48.19138, 11.614412));

//TODO Add start point to route
String defaultStartPoint = 'München - Bavariapark';
String startPoint = 'München - Bavariapark';

const String emptySponsorPlaceholder = kIsWeb
    ? 'assets/images/2025_Bladenight_Logo_Skm.jpg'
    : 'assets/images/2025_Bladenight_Logo_Skm.jpg';

const String secondLogoPlaceholder = 'assets/images/skatemunich.png';

const String skmLogoPlaceholder =
    'assets/images/2025_Skate_Munich_Logo-2845x548_y.png';
const String bnLogoPlaceholder =
    'assets/images/2025_Blade_Night_Logo-2845x548_y.png';
const String specialPointImagePlaceHolder =
    'assets/images/skatemunich_child_orange_circle.png';

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
