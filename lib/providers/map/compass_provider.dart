import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/debug_helper.dart';

part 'compass_provider.g.dart';

@riverpod
class Compass extends _$Compass {
  bool _stopListening = false;

  @override
  double build() {
    debugPrintTime('starting compass build L: $_stopListening');
    if (_stopListening) return 0;
    var listener = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        state = event.heading!;
      }
    });
    ref.onDispose(() {
      listener?.cancel();
      listener = null;
    });
    return 0;
  }

  void stopCompass() {
    debugPrintTime('stopping compass');
    _stopListening = true;
    ref.invalidateSelf();
  }

  void startCompass() {
    debugPrintTime('starting compass');
    _stopListening = false;
    ref.invalidateSelf();
  }
}

final userLocationMarkerHeadingStreamController =
    StreamController<LocationMarkerHeading>.broadcast();

@riverpod
Raw<Stream<LocationMarkerHeading>> rawStream(Ref ref) {
  if (kIsWeb) return userLocationMarkerHeadingStreamController.stream;
  var listener = FlutterCompass.events?.listen((event) {
    if (event.heading != null) {
      userLocationMarkerHeadingStreamController.sink.add(LocationMarkerHeading(
          heading: event.heading ?? 0, accuracy: event.accuracy ?? 0));
    }
  });
  ref.onDispose(() {
    listener?.cancel();
    listener = null;
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
      listener = null;
    });
    return userLocationMarkerHeadingStreamController.stream;
  }
}
