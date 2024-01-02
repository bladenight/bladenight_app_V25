import 'dart:async';
import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';

import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/wamp/message_types.dart';
import '../wamp/bn_wamp_message.dart';
import '../wamp/wamp_endpoints.dart';
import '../wamp/wamp_error.dart';
import '../wamp/wamp_v2.dart';

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
}

@MappableClass(includeCustomMappers: [DurationMapper()])
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
  @MappableField(key: 'sla')
  final double? startPointLatitude;
  @MappableField(key: 'slo')
  final double? startPointLongitude;
  @MappableField(key: 'stp') //startPointInfo
  final String? startPoint;

  @MappableField(key: 'lastupdate')
  late DateTime? lastupdate;

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
      this.lastupdate,
      this.rpcException,
      this.startPointLatitude,
      this.startPointLongitude,
      this.startPoint});

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
    if (status == EventStatus.noevent) {
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
    if (duration.inMinutes ==0 ) return false;
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
    return 0;
  }

  String get  statusText {
    return '${Localize.current.status}: ${Intl.select(status, {
      EventStatus.pending: Localize.current.pending,
      EventStatus.confirmed:
      Localize.current.confirmed,
      EventStatus.cancelled:
      Localize.current.canceled,
      EventStatus.noevent: Localize.current.noEvent,
      EventStatus.running: Localize.current.running,
      EventStatus.finished: Localize.current.finished,
      'other': Localize.current.unknown
    })}';
  }

  static Future<Event> getEventWamp({bool forceUpdate = false}) async {
    if (HiveSettingsDB.actualEventStringString.isNotEmpty &&
        !forceUpdate &&
        DateTime.now().difference(HiveSettingsDB.actualEventLastUpdate) <
            const Duration(seconds: 10)) {
      return MapperContainer.globals
          .fromJson<Event>(HiveSettingsDB.actualEventStringString);
    }

    Completer completer = Completer();
    BnWampMessage bnWampMessage = BnWampMessage(
        WampMessageType.call, completer, WampEndpoint.getActiveEvent);
    var wampResult = await WampV2.instance
        .addToWamp<Event>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => Event.rpcError(error));
    if (wampResult is Map<String, dynamic>) {
      var event = MapperContainer.globals.fromMap<Event>(wampResult);
      event.lastupdate=DateTime.now();
      return event;
    }
    if (wampResult is Event) {
      if (HiveSettingsDB.actualEventStringString.isNotEmpty &&
          DateTime.now()
                  .toUtc()
                  .difference(HiveSettingsDB.actualEventLastUpdate) <
              const Duration(minutes: 5)) {
        var event = MapperContainer.globals
            .fromJson<Event>(HiveSettingsDB.actualEventStringString);
        event.rpcException = wampResult.rpcException;
        return event;
      }
      return wampResult;
    }
    return Event.rpcError(Exception(WampError('unknown')));
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
    var wampResult = await WampV2.instance
        .addToWamp<Events>(bnWampMessage)
        .timeout(wampTimeout)
        .catchError((error, stackTrace) => Events.rpcError(error));
    if (wampResult is Map<String, dynamic>) {
      var rp = MapperContainer.globals.fromMap<Events>(wampResult);
      HiveSettingsDB.setEventsJson(rp.toJson());
      return rp;
    }
    if (wampResult is Events) {
      if (HiveSettingsDB.eventsJson.isNotEmpty) {
        var events = HiveSettingsDB.eventsJson;
        return MapperContainer.globals.fromJson<Events>(events);
      }
      return wampResult;
    }
    return Events.rpcError(Exception(WampError('unknown')));
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
