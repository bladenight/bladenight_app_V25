import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';

import '../generated/l10n.dart';
import '../helpers/timeconverter_helper.dart';
import 'event.dart';

part 'watch_event.mapper.dart';

//Helper class for watch communication
@MappableClass()
class WatchEvent with WatchEventMappable {
  @MappableField(key: 'tit')
  final String title;
  @MappableField(key: 'sta')
  final String startDate;
  @MappableField(key: 'rou')
  final String routeName;

  ///Duration in minutes
  @MappableField(key: 'dur')
  final int duration;
  @MappableField(key: 'par')
  final int participants;
  @MappableField(key: 'sts')
  final String status;

  ///Formatted route length
  @MappableField(key: 'len')
  final String routeLength;
  @MappableField(key: 'sla')
  final double? startPointLatitude;
  @MappableField(key: 'slo')
  final double? startPointLongitude;
  @MappableField(key: 'stp') //startPointInfo
  final String? startPoint;
  @MappableField(key: 'lastupdate')
  late String? lastupdate;

  Exception? rpcException;

  WatchEvent(
      {required this.title,
        required this.startDate,
      required this.routeName,
      this.duration = 240,
      this.participants = 0,
      this.routeLength = '0 m',
      this.status = '-',
      this.lastupdate,
      this.rpcException,
      this.startPointLatitude,
      this.startPointLongitude,
      this.startPoint});

  @override
  String toString() {
    return ', $routeName,$status,length:$routeLength,$startDate';
  }

  static WatchEvent copyFrom(Event event) {
    var date = DateFormatter(Localize.current)
        .getLocalDayDateTimeRepresentation(event.getUtcIso8601DateTime);

    WatchEvent watchEvent =
        WatchEvent(title: Localize.current.nextEvent, startDate: date, routeName: event.routeName)
          ..lastupdate = event.lastupdate == null
              ? '-'
              : Localize.current.dateTimeIntl(
                  event.lastupdate as DateTime,
                  event.lastupdate as DateTime,
                );

    return watchEvent.copyWith(
      duration: event.duration.inMinutes,
      participants: event.participants,
      status: event.statusText,
      routeLength: event.formatDistance,
      startPointLatitude: event.startPointLatitude,
      startPointLongitude: event.startPointLongitude,
      startPoint: event.startPoint,
    );
  }
}

@MappableClass()
class WatchEvents with WatchEventsMappable {
  @MappableField(key: 'evt')
  final List<WatchEvent> events;

  Exception? rpcException;

  WatchEvents(this.events, [this.rpcException]);

  static WatchEvents rpcError(Exception exception) {
    return WatchEvents([], exception);
  }
}
