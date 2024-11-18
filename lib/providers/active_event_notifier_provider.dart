import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/location_bearing_distance.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/watch_communication_helper.dart';
import '../models/event.dart';
import '../models/route.dart';

class ActiveEventProviderOld extends ChangeNotifier {
  static final ActiveEventProviderOld instance = ActiveEventProviderOld._();

  ActiveEventProviderOld._() {
    init();
  }

  void init() async {
    _event = HiveSettingsDB.getActualEvent;
    _providerLastUpdate = _event.lastUpdate ?? DateTime(2000, 1, 1, 0, 0, 0);
    notifyListeners();
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
        /*if (rpcEvent.status != EventStatus.noevent && rpcEvent.isOver) {
          _event = rpcEvent.copyWith(status:  EventStatus.finished);
        }*/
        _event = rpcEvent;
        SendToWatch.updateEvent(rpcEvent);
        var oldEventInPrefs = HiveSettingsDB.getActualEvent;
        //get routepoints on eventupdate to update Map
        if (oldEventInPrefs.compareTo(rpcEvent) != 0 || _routePoints.isEmpty) {
          HiveSettingsDB.setActualEvent(rpcEvent);
          await _updateRoutePoints(rpcEvent);
          if ((DateTime.now().difference(_providerLastUpdate)).inSeconds > 30) {
            //avoid multiple notifications on force update
            if (!kIsWeb && event.status != EventStatus.finished) {
              NotificationHelper().updateNotifications(oldEventInPrefs, _event);
            }
          }
        }
        _providerLastUpdate = DateTime.now();
      }
    } catch (e) {
      print(e);
      _event = HiveSettingsDB.getActualEvent;
      _providerLastUpdate = DateTime.now();
      if (kDebugMode) {
        print('SendToWatch aep94  update Event $event');
      }
      SendToWatch.updateEvent(event);
    }
    notifyListeners();
  }

  Future<void> _updateRoutePoints(Event event) async {
    if (event.status != EventStatus.noevent) {
      var route = await RoutePoints.getActiveRoutePointsWamp();
      if (route.rpcException != null) {
        return;
      }
      _routePoints = route.points;
      _headingPoints = GeoLocationHelper.calculateHeadings(_routePoints);
      if (_routePoints.isNotEmpty) {
        _startPoint = _routePoints.first;
        _finishPoint = _routePoints.last;
      }
      //SendToWatch.setRoutePoints(route);
    } else {
      _routePoints = <LatLng>[];
    }
    notifyListeners();
  }
}

///Get actual or coming [Event] from server
final activeEventProviderOld =
    ChangeNotifierProvider((ref) => ActiveEventProviderOld.instance);
