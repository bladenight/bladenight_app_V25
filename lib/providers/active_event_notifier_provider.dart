import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/preferences_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';
import '../models/route.dart';

class ActiveEventProvider extends ChangeNotifier {
  static final ActiveEventProvider instance = ActiveEventProvider._();

  ActiveEventProvider._() {
    init();
  }

  void init() async {
    _event = await PreferencesHelper.getEventFromPrefs();
    _providerLastUpdate = _event.lastupdate ?? DateTime(2000, 1, 1, 0, 0, 0);
    notifyListeners();
    //refresh();
  }

  DateTime _providerLastUpdate = DateTime(2000, 1, 1, 0, 0, 0);
  Event _event = Event.init;
  List<LatLng> _routePoints = <LatLng>[];
  List<HeadingPoint> _headingPoints = <HeadingPoint>[];

  DateTime? get lastUpdate => _providerLastUpdate;

  Event get event => _event;

  List<LatLng> get activeEventRoutePoints => _routePoints;

  LatLng get startPoint => _startPoint;

  LatLng get finishPoint => _finishPoint;

  LatLng _startPoint = defaultLatLng;
  LatLng _finishPoint = defaultLatLng;

  List<HeadingPoint> get headingPoints => _headingPoints;

  bool get appIsOutdated => _appIsOutdated;
  bool _appIsOutdated = false;

  //save to prefs
  void saveToPrefs({required Event event}) async {
    event.lastupdate ??= DateTime.now();
    await PreferencesHelper.saveEventToPrefs(event);
  }

  void setAppOutDatedState(bool appIsOutdated) {
    _appIsOutdated = appIsOutdated;
    notifyListeners();
  }

  ///Refresh [Event]
  Future<void> refresh({bool forceUpdate = false}) async {
    try {
      //avoid permanent trigger
      var diffSec = DateTime.now().difference(_providerLastUpdate).inSeconds;
      if (diffSec > 10 || forceUpdate) {
        var rpcEvent = await Event.getEventWamp(forceUpdate: forceUpdate);
        if (rpcEvent.rpcException != null) {
          _event.rpcException = rpcEvent.rpcException;
          notifyListeners();
          return;
        }
        _event =
            rpcEvent.isNoEventPlannedOrInvalidDuration ? Event.init : rpcEvent;
        SendToWatch.updateEvent(rpcEvent);
        var oldEventInPrefs = await PreferencesHelper.getEventFromPrefs();
        //get routepoints on eventupdate to update Map
        if (oldEventInPrefs.compareTo(rpcEvent) != 0 || _routePoints.isEmpty) {
          await PreferencesHelper.saveEventToPrefs(rpcEvent);
          await _updateRoutePoints(rpcEvent);
          if ((DateTime.now().difference(_providerLastUpdate)).inSeconds > 30) {
            //avoid multiple notifications on forceupdate
            if (!kIsWeb) {
              NotificationHelper().updateNotifications(oldEventInPrefs, _event);
            }
          }
        }
        _providerLastUpdate = DateTime.now();
        _event.lastupdate = _providerLastUpdate;
      }
    } catch (e) {
      print(e);
      _event = await PreferencesHelper.getEventFromPrefs();
      _providerLastUpdate = DateTime.now();
      SendToWatch.updateEvent(event);
    }
    notifyListeners();
  }

  Future<void> _updateRoutePoints(Event event) async {
    print('_updateRoutePoints ${event.isNoEventPlannedOrInvalidDuration}');
    if (!event.isNoEventPlannedOrInvalidDuration) {
      var route = await RoutePoints.getActiveRoutePointsWamp();
      if (route.rpcException != null) {
        return;
      }
      _routePoints = route.points ?? <LatLng>[];
      _headingPoints = GeoLocationHelper.calculateHeadings(_routePoints);
      if (_routePoints.isNotEmpty) {
        _startPoint = _routePoints.first;
        _finishPoint = _routePoints.last;
      }
      SendToWatch.setRoutePoints(route);
    } else {
      _routePoints = <LatLng>[];
    }
    notifyListeners();
  }
}

///Get actual or coming [Event] from server
final activeEventProvider =
    ChangeNotifierProvider((ref) => ActiveEventProvider.instance);
