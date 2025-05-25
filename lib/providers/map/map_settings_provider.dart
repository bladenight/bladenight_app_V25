import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_settings/app_constants.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

part 'map_settings_provider.g.dart';

@riverpod
class ShowOwnTrack extends _$ShowOwnTrack {
  @override
  bool build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: MapSettings.showOwnTrackKey)
        .listen((event) => state = event.value);

    ref.onDispose(() {
      listener.cancel();
    });
    return MapSettings.showOwnTrack;
  }

  void setValue(bool val) {
    MapSettings.setShowOwnTrack(val);
  }
}

@riverpod
class ShowOwnColoredTrack extends _$ShowOwnColoredTrack {
  @override
  bool build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: MapSettings.showOwnColoredTrackKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return MapSettings.showOwnColoredTrack;
  }

  void setValue(bool val) {
    MapSettings.setShowOwnColoredTrack(val);
  }
}

@riverpod
class ShowCompass extends _$ShowCompass {
  @override
  bool build() {
    var listener = Hive.box(hiveBoxSettingDbName)
        .watch(key: MapSettings.compassVisibleKey)
        .listen((event) => state = event.value);
    ref.onDispose(() {
      listener.cancel();
    });
    return MapSettings.compassVisible;
  }

  void setValue(bool val) {
    MapSettings.setCompassVisible(val);
  }
}
