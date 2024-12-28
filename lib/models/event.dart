import 'dart:async';
import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/time_converter_helper.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_exception.dart';
import '../wamp/wamp_v2.dart';
import 'lat_lng_mapper.dart';
import 'start_point.dart';

part 'event.mapper.dart';

@MappableEnum()
enum EventStatus {
  @MappableValue('PEN')
  pending,
  @MappableValue('CON')
  confirmed,
  @MappableValue('CAN')
  cancelled,
  @MappableValue('NOE')
  noevent,

  ///Event actual running
  @MappableValue('RUN')
  running,

  ///Event actual finished
  @MappableValue('FIN')
  finished,

  ///Event actual finished
  @MappableValue('DEL')
  deleted,

  ///Event actual finished
  @MappableValue('UKN')
  unknown,
}

@MappableClass(
    includeCustomMappers: [DurationMapper(), DateTimeMapper(), LatLngMapper()])
class Event with EventMappable implements Comparable {
  @MappableField(key: 'sta')
  final DateTime startDate;
  @MappableField(key: 'dur')
  final Duration duration;
  @MappableField(key: 'rou')
  final String routeName;
  @MappableField(key: 'par')
  final int participants;
  @MappableField(key: 'sts')
  final EventStatus status;
  @MappableField(key: 'len')
  final int routeLength;

  ///Route points aka nodes
  @MappableField(key: 'nod')
  List<LatLng> nodes = <LatLng>[];
  @MappableField(key: 'sla')
  final double? startPointLatitude;
  @MappableField(key: 'slo')
  final double? startPointLongitude;
  @MappableField(key: 'stp') //startPointInfo
  final String? startPoint;
  @MappableField(
      key:
          'isa') //event is running - means it't after start time or manual active
  final bool isActive;

  @MappableField(key: 'lastupdate')
  late DateTime? lastUpdate;

  Exception? rpcException;

  static Event rpcError(Exception exception) {
    return Event(
        startDate: DateTime.now().toUtc(),
        routeName: Localize.current.noEventStarted,
        duration: initDaysDuration,
        status: EventStatus.noevent,
        rpcException: exception);
  }

  Event(
      {required this.startDate,
      required this.routeName,
      this.duration = const Duration(days: 240),
      this.participants = 0,
      this.routeLength = 0,
      this.status = EventStatus.pending,
      this.nodes = const <LatLng>[],
      this.lastUpdate,
      this.rpcException,
      this.startPointLatitude,
      this.startPointLongitude,
      this.startPoint,
      this.isActive = true});

  @override
  String toString() {
    return ', $routeName,$status,length:$routeLength,$startDate,utc:$startDateUtc';
  }

  ///return [DateTime] as utc because sometimes wrong date was converted or saved (thinking) by mapper
  DateTime get startDateUtc {
    return startDate.toUtc();
  }

  DateTime get getUtcIso8601DateTime {
    return DateTime.parse(startDateUtc.toIso8601String());
  }

  ///Formats the distance of the route to m or kilometers
  String get formatDistance {
    int meters = routeLength;
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

  bool get hasSpecialStartPoint {
    if (startPointLongitude is double &&
        startPointLongitude != 0.0 &&
        startPointLatitude is double &&
        startPointLongitude != 0.0) {
      return true;
    }
    return false;
  }

  Color get statusColor {
    switch (status) {
      case EventStatus.pending:
        return Colors.yellowAccent;
      case EventStatus.confirmed:
        return Colors.green;
      case EventStatus.cancelled:
        return Colors.red;
      case EventStatus.noevent:
        return Colors.grey;
      case EventStatus.running:
        return Colors.green;
      case EventStatus.finished:
        return Colors.blueAccent;
      case EventStatus.deleted:
        return Colors.grey;
      case EventStatus.unknown:
        return Colors.transparent;
    }
  }

  Color get statusTextColor {
    switch (status) {
      case EventStatus.pending:
        return Colors.black;
      case EventStatus.confirmed:
        return Colors.black;
      case EventStatus.cancelled:
        return Colors.black;
      case EventStatus.noevent:
        return Colors.black;
      case EventStatus.running:
        return Colors.black;
      case EventStatus.finished:
        return Colors.black;
      case EventStatus.deleted:
        return Colors.black;
      case EventStatus.unknown:
        return Colors.black;
    }
  }

  ///returns an image independent on status red, yellow, green, off horizontal
  String get trafficLight {
    switch (status) {
      case EventStatus.pending:
        return 'assets/images/event/traffic_yellow.png';
      case EventStatus.confirmed:
        return 'assets/images/event/traffic_green.png';
      case EventStatus.cancelled:
        return 'assets/images/event/traffic_red.png';
      case EventStatus.noevent:
        return 'assets/images/event/traffic_none.png';
      case EventStatus.running:
        return 'assets/images/event/traffic_green.png';
      case EventStatus.finished:
        return 'assets/images/finishMarker.png';
      case EventStatus.deleted:
        return 'assets/images/event/traffic_none.png';
      case EventStatus.unknown:
        return 'assets/images/event/traffic_none.png';
    }
  }

  ///Returns a base [Event] dated to now with with duration [initDaysDuration] of 3650 days to see its not actual
  static Event get init {
    return Event(
        startDate: DateTime.now().toUtc(),
        routeName: Localize.current.noEventStarted,
        duration: initDaysDuration,
        status: EventStatus.noevent);
  }

  static Duration get initDaysDuration {
    return const Duration(days: 3650);
  }

  ///Check if event is over
  ///Event is always in Future added by duration
  bool get isNoEventPlanned {
    if (status == EventStatus.noevent || status == EventStatus.unknown) {
      return true;
    }
    return false;
  }

  ///Check for [Event] is over
  ///
  /// Returns true if over
  /// or false if not
  ///
  /// if Event duration is zero return always false
  bool get isOver {
    if (duration.inMinutes == 0) return false;
    var eventDifference =
        startDate.toUtc().add(duration).difference(DateTime.now().toUtc());
    return eventDifference.isNegative;
  }

  @override
  int compareTo(other) {
    if (other.runtimeType != Event) return 999;
    var otherEvent = other as Event;
    if (status.index != otherEvent.status.index) {
      return 50;
    }
    if (routeName.compareTo(otherEvent.routeName) != 0) {
      return 100;
    }
    //compare only utc time because sometimes server date wrong interpreted
    if (startDate.toUtc().compareTo(otherEvent.startDate.toUtc()) != 0) {
      return 150;
    }
    if (nodes.length.compareTo(otherEvent.nodes.length) != 0) {
      return 200;
    }
    if (nodes.hashCode.compareTo(otherEvent.nodes.hashCode) != 0) {
      return 250;
    }
    return 0;
  }

  String get statusText {
    return '${Localize.current.status}: ${Intl.select(status, {
          EventStatus.pending: Localize.current.pending,
          EventStatus.confirmed: Localize.current.confirmed,
          EventStatus.cancelled: Localize.current.canceled,
          EventStatus.noevent: Localize.current.noEvent,
          EventStatus.running: Localize.current.running,
          EventStatus.finished: Localize.current.finished,
          EventStatus.deleted: Localize.current.delete,
          'other': Localize.current.unknown
        })}';
  }

  LocationPoint get getStartPoint {
    if (startPointLatitude == null || startPointLongitude == null) {
      return LocationPoint(startPoint ?? defaultStartPoint, defaultLatLng);
    }
    return LocationPoint(startPoint ?? defaultStartPoint,
        LatLng(startPointLatitude!, startPointLongitude!));
  }

  static Future<Event> getEventWamp({bool forceUpdate = false}) async {
    if (HiveSettingsDB.actualEventAsJson.isNotEmpty &&
        !forceUpdate &&
        DateTime.now().difference(HiveSettingsDB.actualEventLastUpdate) <
            const Duration(seconds: 10)) {
      return MapperContainer.globals
          .fromJson<Event>(HiveSettingsDB.actualEventAsJson);
    }

    Completer? completer = Completer();
    BnWampMessage? bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getActiveEvent);
    var wampResult = await WampV2()
        .addToWamp<Event>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) =>
            Event.rpcError(WampException(error.toString())));
    bnWampMessage = null;
    completer = null;
    if (wampResult is Map<String, dynamic>) {
      var event = MapperContainer.globals.fromMap<Event>(wampResult);
      event.lastUpdate = DateTime.now();
      return event;
    }
    if (wampResult is Event) {
      if (HiveSettingsDB.actualEventAsJson.isNotEmpty &&
          DateTime.now()
                  .toUtc()
                  .difference(HiveSettingsDB.actualEventLastUpdate) <
              const Duration(minutes: 5)) {
        var event = MapperContainer.globals
            .fromJson<Event>(HiveSettingsDB.actualEventAsJson);
        event.rpcException = wampResult.rpcException;
        return event;
      }
      return wampResult;
    }
    return Event.rpcError(WampException('unknown'));
  }
}

@MappableClass()
class Events with EventsMappable {
  @MappableField(key: 'evt')
  final List<Event> events;

  Exception? rpcException;

  Events(this.events, [this.rpcException]);

  static Events rpcError(Exception exception) {
    return Events([], exception);
  }

  static Future<Events> getAllEventsWamp() async {
    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getallevents);
    var wampResult = await WampV2()
        .addToWamp<Events>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) =>
            Events.rpcError(WampException(error.toString())));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<Events>(wampResult);
      HiveSettingsDB.setEventsJson(rp.toJson());
      return rp;
    }
    if (wampResult is Events && wampResult.rpcException != null) {
      if (HiveSettingsDB.eventsJson.isNotEmpty) {
        var events = HiveSettingsDB.eventsJson;
        return MapperContainer.globals.fromJson<Events>(events);
      }
      return wampResult;
    }
    return Events.rpcError(WampException('unknown'));
  }

  Map<String, Events> groupByYear() {
    var resultMap = <String, Events>{};
    events.sort((e1, e2) => e1.startDateUtc.compareTo(e2.startDateUtc));
    for (var event in events) {
      if (!resultMap.keys.contains(event.startDate.year.toString())) {
        resultMap[event.startDate.year.toString()] = Events([event]);
        continue;
      }
      var eventsList = resultMap[event.startDate.year.toString()]!.events;
      eventsList.add(event);
    }
    var sortedByKeyMap = Map.fromEntries(
        resultMap.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));
    return sortedByKeyMap;
  }
}

class DurationMapper extends SimpleMapper<Duration> {
  const DurationMapper();

  @override
  Duration decode(value) {
    return Duration(minutes: value as int);
  }

  @override
  encode(Duration self) {
    return self.inMinutes;
  }
}

class DateTimeMapper extends SimpleMapper<DateTime> {
  const DateTimeMapper();

  @override
  DateTime decode(value) {
    try {
      var val = DateTime.parse(value.toString());
      return val;
    } catch (e) {
      BnLog.error(text: 'Could not parse $value');
      rethrow;
    }
  }

  @override
  encode(DateTime self) {
    //2023-05-08T21:00:00.000+02:00
    try {
      var val = self.toEventMessageDateTime();
      return val;
    } catch (e) {
      return self.toUtc().toIso8601String();
    }
  }
}
