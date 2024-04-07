// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'watch_event.dart';

class WatchEventMapper extends ClassMapperBase<WatchEvent> {
  WatchEventMapper._();

  static WatchEventMapper? _instance;
  static WatchEventMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WatchEventMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'WatchEvent';

  static String _$title(WatchEvent v) => v.title;
  static const Field<WatchEvent, String> _f$title =
      Field('title', _$title, key: 'tit');
  static String _$startDate(WatchEvent v) => v.startDate;
  static const Field<WatchEvent, String> _f$startDate =
      Field('startDate', _$startDate, key: 'sta');
  static String _$routeName(WatchEvent v) => v.routeName;
  static const Field<WatchEvent, String> _f$routeName =
      Field('routeName', _$routeName, key: 'rou');
  static int _$duration(WatchEvent v) => v.duration;
  static const Field<WatchEvent, int> _f$duration =
      Field('duration', _$duration, key: 'dur', opt: true, def: 240);
  static int _$participants(WatchEvent v) => v.participants;
  static const Field<WatchEvent, int> _f$participants =
      Field('participants', _$participants, key: 'par', opt: true, def: 0);
  static String _$routeLength(WatchEvent v) => v.routeLength;
  static const Field<WatchEvent, String> _f$routeLength =
      Field('routeLength', _$routeLength, key: 'len', opt: true, def: '0 m');
  static String _$status(WatchEvent v) => v.status;
  static const Field<WatchEvent, String> _f$status =
      Field('status', _$status, key: 'sts', opt: true, def: '-');
  static String? _$lastupdate(WatchEvent v) => v.lastupdate;
  static const Field<WatchEvent, String> _f$lastupdate =
      Field('lastupdate', _$lastupdate, opt: true);
  static Exception? _$rpcException(WatchEvent v) => v.rpcException;
  static const Field<WatchEvent, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);
  static double? _$startPointLatitude(WatchEvent v) => v.startPointLatitude;
  static const Field<WatchEvent, double> _f$startPointLatitude =
      Field('startPointLatitude', _$startPointLatitude, key: 'sla', opt: true);
  static double? _$startPointLongitude(WatchEvent v) => v.startPointLongitude;
  static const Field<WatchEvent, double> _f$startPointLongitude = Field(
      'startPointLongitude', _$startPointLongitude,
      key: 'slo', opt: true);
  static String? _$startPoint(WatchEvent v) => v.startPoint;
  static const Field<WatchEvent, String> _f$startPoint =
      Field('startPoint', _$startPoint, key: 'stp', opt: true);

  @override
  final MappableFields<WatchEvent> fields = const {
    #title: _f$title,
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

  static WatchEvent _instantiate(DecodingData data) {
    return WatchEvent(
        title: data.dec(_f$title),
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

  static WatchEvent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WatchEvent>(map);
  }

  static WatchEvent fromJson(String json) {
    return ensureInitialized().decodeJson<WatchEvent>(json);
  }
}

mixin WatchEventMappable {
  String toJson() {
    return WatchEventMapper.ensureInitialized()
        .encodeJson<WatchEvent>(this as WatchEvent);
  }

  Map<String, dynamic> toMap() {
    return WatchEventMapper.ensureInitialized()
        .encodeMap<WatchEvent>(this as WatchEvent);
  }

  WatchEventCopyWith<WatchEvent, WatchEvent, WatchEvent> get copyWith =>
      _WatchEventCopyWithImpl(this as WatchEvent, $identity, $identity);
  @override
  String toString() {
    return WatchEventMapper.ensureInitialized()
        .stringifyValue(this as WatchEvent);
  }

  @override
  bool operator ==(Object other) {
    return WatchEventMapper.ensureInitialized()
        .equalsValue(this as WatchEvent, other);
  }

  @override
  int get hashCode {
    return WatchEventMapper.ensureInitialized().hashValue(this as WatchEvent);
  }
}

extension WatchEventValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WatchEvent, $Out> {
  WatchEventCopyWith<$R, WatchEvent, $Out> get $asWatchEvent =>
      $base.as((v, t, t2) => _WatchEventCopyWithImpl(v, t, t2));
}

abstract class WatchEventCopyWith<$R, $In extends WatchEvent, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? title,
      String? startDate,
      String? routeName,
      int? duration,
      int? participants,
      String? routeLength,
      String? status,
      String? lastupdate,
      Exception? rpcException,
      double? startPointLatitude,
      double? startPointLongitude,
      String? startPoint});
  WatchEventCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WatchEventCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WatchEvent, $Out>
    implements WatchEventCopyWith<$R, WatchEvent, $Out> {
  _WatchEventCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WatchEvent> $mapper =
      WatchEventMapper.ensureInitialized();
  @override
  $R call(
          {String? title,
          String? startDate,
          String? routeName,
          int? duration,
          int? participants,
          String? routeLength,
          String? status,
          Object? lastupdate = $none,
          Object? rpcException = $none,
          Object? startPointLatitude = $none,
          Object? startPointLongitude = $none,
          Object? startPoint = $none}) =>
      $apply(FieldCopyWithData({
        if (title != null) #title: title,
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
  WatchEvent $make(CopyWithData data) => WatchEvent(
      title: data.get(#title, or: $value.title),
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
  WatchEventCopyWith<$R2, WatchEvent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WatchEventCopyWithImpl($value, $cast, t);
}

class WatchEventsMapper extends ClassMapperBase<WatchEvents> {
  WatchEventsMapper._();

  static WatchEventsMapper? _instance;
  static WatchEventsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WatchEventsMapper._());
      WatchEventMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WatchEvents';

  static List<WatchEvent> _$events(WatchEvents v) => v.events;
  static const Field<WatchEvents, List<WatchEvent>> _f$events =
      Field('events', _$events, key: 'evt');
  static Exception? _$rpcException(WatchEvents v) => v.rpcException;
  static const Field<WatchEvents, Exception> _f$rpcException =
      Field('rpcException', _$rpcException, opt: true);

  @override
  final MappableFields<WatchEvents> fields = const {
    #events: _f$events,
    #rpcException: _f$rpcException,
  };

  static WatchEvents _instantiate(DecodingData data) {
    return WatchEvents(data.dec(_f$events), data.dec(_f$rpcException));
  }

  @override
  final Function instantiate = _instantiate;

  static WatchEvents fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WatchEvents>(map);
  }

  static WatchEvents fromJson(String json) {
    return ensureInitialized().decodeJson<WatchEvents>(json);
  }
}

mixin WatchEventsMappable {
  String toJson() {
    return WatchEventsMapper.ensureInitialized()
        .encodeJson<WatchEvents>(this as WatchEvents);
  }

  Map<String, dynamic> toMap() {
    return WatchEventsMapper.ensureInitialized()
        .encodeMap<WatchEvents>(this as WatchEvents);
  }

  WatchEventsCopyWith<WatchEvents, WatchEvents, WatchEvents> get copyWith =>
      _WatchEventsCopyWithImpl(this as WatchEvents, $identity, $identity);
  @override
  String toString() {
    return WatchEventsMapper.ensureInitialized()
        .stringifyValue(this as WatchEvents);
  }

  @override
  bool operator ==(Object other) {
    return WatchEventsMapper.ensureInitialized()
        .equalsValue(this as WatchEvents, other);
  }

  @override
  int get hashCode {
    return WatchEventsMapper.ensureInitialized().hashValue(this as WatchEvents);
  }
}

extension WatchEventsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WatchEvents, $Out> {
  WatchEventsCopyWith<$R, WatchEvents, $Out> get $asWatchEvents =>
      $base.as((v, t, t2) => _WatchEventsCopyWithImpl(v, t, t2));
}

abstract class WatchEventsCopyWith<$R, $In extends WatchEvents, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, WatchEvent, WatchEventCopyWith<$R, WatchEvent, WatchEvent>>
      get events;
  $R call({List<WatchEvent>? events, Exception? rpcException});
  WatchEventsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WatchEventsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WatchEvents, $Out>
    implements WatchEventsCopyWith<$R, WatchEvents, $Out> {
  _WatchEventsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WatchEvents> $mapper =
      WatchEventsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, WatchEvent, WatchEventCopyWith<$R, WatchEvent, WatchEvent>>
      get events => ListCopyWith($value.events, (v, t) => v.copyWith.$chain(t),
          (v) => call(events: v));
  @override
  $R call({List<WatchEvent>? events, Object? rpcException = $none}) =>
      $apply(FieldCopyWithData({
        if (events != null) #events: events,
        if (rpcException != $none) #rpcException: rpcException
      }));
  @override
  WatchEvents $make(CopyWithData data) => WatchEvents(
      data.get(#events, or: $value.events),
      data.get(#rpcException, or: $value.rpcException));

  @override
  WatchEventsCopyWith<$R2, WatchEvents, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WatchEventsCopyWithImpl($value, $cast, t);
}
