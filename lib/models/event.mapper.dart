// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'event.dart';

class EventStatusMapper extends EnumMapper<EventStatus> {
  EventStatusMapper._();

  static EventStatusMapper? _instance;
  static EventStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EventStatusMapper._());
    }
    return _instance!;
  }

  static EventStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  EventStatus decode(dynamic value) {
    switch (value) {
      case 'PEN':
        return EventStatus.pending;
      case 'CON':
        return EventStatus.confirmed;
      case 'CAN':
        return EventStatus.cancelled;
      case 'NOE':
        return EventStatus.noevent;
      case 'RUN':
        return EventStatus.running;
      case 'FIN':
        return EventStatus.finished;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(EventStatus self) {
    switch (self) {
      case EventStatus.pending:
        return 'PEN';
      case EventStatus.confirmed:
        return 'CON';
      case EventStatus.cancelled:
        return 'CAN';
      case EventStatus.noevent:
        return 'NOE';
      case EventStatus.running:
        return 'RUN';
      case EventStatus.finished:
        return 'FIN';
    }
  }
}

extension EventStatusMapperExtension on EventStatus {
  dynamic toValue() {
    EventStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<EventStatus>(this);
  }
}

class EventMapper extends ClassMapperBase<Event> {
  EventMapper._();

  static EventMapper? _instance;
  static EventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EventMapper._());
      MapperContainer.globals.useAll([DurationMapper()]);
      EventStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Event';

  static DateTime _$startDate(Event v) => v.startDate;
  static const Field<Event, DateTime> _f$startDate =
      Field('startDate', _$startDate, key: 'sta');
  static String _$routeName(Event v) => v.routeName;
  static const Field<Event, String> _f$routeName =
      Field('routeName', _$routeName, key: 'rou');
  static Duration _$duration(Event v) => v.duration;
  static const Field<Event, Duration> _f$duration = Field(
      'duration', _$duration,
      key: 'dur', opt: true, def: const Duration(days: 240));
  static int _$participants(Event v) => v.participants;
  static const Field<Event, int> _f$participants =
      Field('participants', _$participants, key: 'par', opt: true, def: 0);
  static int _$routeLength(Event v) => v.routeLength;
  static const Field<Event, int> _f$routeLength =
      Field('routeLength', _$routeLength, key: 'len', opt: true, def: 0);
  static EventStatus _$status(Event v) => v.status;
  static const Field<Event, EventStatus> _f$status = Field('status', _$status,
      key: 'sts', opt: true, def: EventStatus.pending);
  static DateTime? _$lastupdate(Event v) => v.lastupdate;
  static const Field<Event, DateTime> _f$lastupdate =
      Field('lastupdate', _$lastupdate, opt: true);
  static Exception? _$rpcException(Event v) => v.rpcException;
  static const Field<Event, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);
  static double? _$startPointLatitude(Event v) => v.startPointLatitude;
  static const Field<Event, double> _f$startPointLatitude =
      Field('startPointLatitude', _$startPointLatitude, key: 'sla', opt: true);
  static double? _$startPointLongitude(Event v) => v.startPointLongitude;
  static const Field<Event, double> _f$startPointLongitude = Field(
      'startPointLongitude', _$startPointLongitude,
      key: 'slo', opt: true);
  static String? _$startPoint(Event v) => v.startPoint;
  static const Field<Event, String> _f$startPoint =
      Field('startPoint', _$startPoint, key: 'stp', opt: true);

  @override
  final MappableFields<Event> fields = const {
    #startDate: _f$startDate,
    #routeName: _f$routeName,
    #duration: _f$duration,
    #participants: _f$participants,
    #routeLength: _f$routeLength,
    #status: _f$status,
    #lastupdate: _f$lastupdate,
    #rpcException: _f$rpcException,
    #startPointLatitude: _f$startPointLatitude,
    #startPointLongitude: _f$startPointLongitude,
    #startPoint: _f$startPoint,
  };

  static Event _instantiate(DecodingData data) {
    return Event(
        startDate: data.dec(_f$startDate),
        routeName: data.dec(_f$routeName),
        duration: data.dec(_f$duration),
        participants: data.dec(_f$participants),
        routeLength: data.dec(_f$routeLength),
        status: data.dec(_f$status),
        lastupdate: data.dec(_f$lastupdate),
        rpcException: data.dec(_f$rpcException),
        startPointLatitude: data.dec(_f$startPointLatitude),
        startPointLongitude: data.dec(_f$startPointLongitude),
        startPoint: data.dec(_f$startPoint));
  }

  @override
  final Function instantiate = _instantiate;

  static Event fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Event>(map);
  }

  static Event fromJson(String json) {
    return ensureInitialized().decodeJson<Event>(json);
  }
}

mixin EventMappable {
  String toJson() {
    return EventMapper.ensureInitialized().encodeJson<Event>(this as Event);
  }

  Map<String, dynamic> toMap() {
    return EventMapper.ensureInitialized().encodeMap<Event>(this as Event);
  }

  EventCopyWith<Event, Event, Event> get copyWith =>
      _EventCopyWithImpl(this as Event, $identity, $identity);
  @override
  String toString() {
    return EventMapper.ensureInitialized().stringifyValue(this as Event);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            EventMapper.ensureInitialized().isValueEqual(this as Event, other));
  }

  @override
  int get hashCode {
    return EventMapper.ensureInitialized().hashValue(this as Event);
  }
}

extension EventValueCopy<$R, $Out> on ObjectCopyWith<$R, Event, $Out> {
  EventCopyWith<$R, Event, $Out> get $asEvent =>
      $base.as((v, t, t2) => _EventCopyWithImpl(v, t, t2));
}

abstract class EventCopyWith<$R, $In extends Event, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {DateTime? startDate,
      String? routeName,
      Duration? duration,
      int? participants,
      int? routeLength,
      EventStatus? status,
      DateTime? lastupdate,
      Exception? rpcException,
      double? startPointLatitude,
      double? startPointLongitude,
      String? startPoint});
  EventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EventCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Event, $Out>
    implements EventCopyWith<$R, Event, $Out> {
  _EventCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Event> $mapper = EventMapper.ensureInitialized();
  @override
  $R call(
          {DateTime? startDate,
          String? routeName,
          Duration? duration,
          int? participants,
          int? routeLength,
          EventStatus? status,
          Object? lastupdate = $none,
          Object? rpcException = $none,
          Object? startPointLatitude = $none,
          Object? startPointLongitude = $none,
          Object? startPoint = $none}) =>
      $apply(FieldCopyWithData({
        if (startDate != null) #startDate: startDate,
        if (routeName != null) #routeName: routeName,
        if (duration != null) #duration: duration,
        if (participants != null) #participants: participants,
        if (routeLength != null) #routeLength: routeLength,
        if (status != null) #status: status,
        if (lastupdate != $none) #lastupdate: lastupdate,
        if (rpcException != $none) #rpcException: rpcException,
        if (startPointLatitude != $none)
          #startPointLatitude: startPointLatitude,
        if (startPointLongitude != $none)
          #startPointLongitude: startPointLongitude,
        if (startPoint != $none) #startPoint: startPoint
      }));
  @override
  Event $make(CopyWithData data) => Event(
      startDate: data.get(#startDate, or: $value.startDate),
      routeName: data.get(#routeName, or: $value.routeName),
      duration: data.get(#duration, or: $value.duration),
      participants: data.get(#participants, or: $value.participants),
      routeLength: data.get(#routeLength, or: $value.routeLength),
      status: data.get(#status, or: $value.status),
      lastupdate: data.get(#lastupdate, or: $value.lastupdate),
      rpcException: data.get(#rpcException, or: $value.rpcException),
      startPointLatitude:
          data.get(#startPointLatitude, or: $value.startPointLatitude),
      startPointLongitude:
          data.get(#startPointLongitude, or: $value.startPointLongitude),
      startPoint: data.get(#startPoint, or: $value.startPoint));

  @override
  EventCopyWith<$R2, Event, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EventCopyWithImpl($value, $cast, t);
}

class EventsMapper extends ClassMapperBase<Events> {
  EventsMapper._();

  static EventsMapper? _instance;
  static EventsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EventsMapper._());
      EventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Events';

  static List<Event> _$events(Events v) => v.events;
  static const Field<Events, List<Event>> _f$events =
      Field('events', _$events, key: 'evt');
  static Exception? _$rpcException(Events v) => v.rpcException;
  static const Field<Events, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final MappableFields<Events> fields = const {
    #events: _f$events,
    #rpcException: _f$rpcException,
  };

  static Events _instantiate(DecodingData data) {
    return Events(data.dec(_f$events), data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static Events fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Events>(map);
  }

  static Events fromJson(String json) {
    return ensureInitialized().decodeJson<Events>(json);
  }
}

mixin EventsMappable {
  String toJson() {
    return EventsMapper.ensureInitialized().encodeJson<Events>(this as Events);
  }

  Map<String, dynamic> toMap() {
    return EventsMapper.ensureInitialized().encodeMap<Events>(this as Events);
  }

  EventsCopyWith<Events, Events, Events> get copyWith =>
      _EventsCopyWithImpl(this as Events, $identity, $identity);
  @override
  String toString() {
    return EventsMapper.ensureInitialized().stringifyValue(this as Events);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            EventsMapper.ensureInitialized()
                .isValueEqual(this as Events, other));
  }

  @override
  int get hashCode {
    return EventsMapper.ensureInitialized().hashValue(this as Events);
  }
}

extension EventsValueCopy<$R, $Out> on ObjectCopyWith<$R, Events, $Out> {
  EventsCopyWith<$R, Events, $Out> get $asEvents =>
      $base.as((v, t, t2) => _EventsCopyWithImpl(v, t, t2));
}

abstract class EventsCopyWith<$R, $In extends Events, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Event, EventCopyWith<$R, Event, Event>> get events;
  $R call({List<Event>? events, Exception? rpcException});
  EventsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EventsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Events, $Out>
    implements EventsCopyWith<$R, Events, $Out> {
  _EventsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Events> $mapper = EventsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Event, EventCopyWith<$R, Event, Event>> get events =>
      ListCopyWith($value.events, (v, t) => v.copyWith.$chain(t),
          (v) => call(events: v));
  @override
  $R call({List<Event>? events, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (events != null) #events: events,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  Events $make(CopyWithData data) => Events(
      data.get(#events, or: $value.events),
      data.get(#rpcException, or: $value.rpcException));

  @override
  EventsCopyWith<$R2, Events, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EventsCopyWithImpl($value, $cast, t);
}
