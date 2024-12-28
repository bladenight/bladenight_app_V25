import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_compass/flutter_compass.dart' show FlutterCompass;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compass_provider.g.dart';

@riverpod
class Compass extends _$Compass {
  bool _stopListening = false;

  @override
  double build() {
    debugPrint('starting compass build L: $_stopListening');
    if (_stopListening) return 0;
    var listener = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        state = event.heading!;
      }
    });
    ref.onDispose(() {
      listener?.cancel();
    });
    return 0;
  }

  void stopCompass() {
    print('stopping compass');
    _stopListening = true;
    ref.invalidateSelf();
  }

  void startCompass() {
    print('starting compass');
    _stopListening = false;
    ref.invalidateSelf();
  }
}

final userLocationMarkerHeadingStreamController =
    StreamController<LocationMarkerHeading>.broadcast();

@riverpod
Raw<Stream<LocationMarkerHeading>> rawStream(RawStreamRef ref) {
  var listener = FlutterCompass.events?.listen((event) {
    if (event.heading != null) {
      userLocationMarkerHeadingStreamController.sink.add(LocationMarkerHeading(
          heading: event.heading ?? 0, accuracy: event.accuracy ?? 0));
    }
  });
  ref.onDispose(() {
    listener?.cancel();
  });
  return userLocationMarkerHeadingStreamController.stream;
}

@riverpod
class CompassHeading extends _$CompassHeading {
  @override
  Stream<LocationMarkerHeading> build() {
    var listener = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        userLocationMarkerHeadingStreamController.sink.add(
            LocationMarkerHeading(
                heading: event.heading ?? 0, accuracy: event.accuracy ?? 0));
      }
    });
    ref.onDispose(() {
      listener?.cancel();
    });
    return userLocationMarkerHeadingStreamController.stream;
  }
}
