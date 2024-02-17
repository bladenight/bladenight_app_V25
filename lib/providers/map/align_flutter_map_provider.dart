import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/follow_location_state.dart';

part 'align_flutter_map_provider.g.dart';

@Riverpod(keepAlive: true)
class AlignFlutterMap extends _$AlignFlutterMap {

  @override
  AlignFlutterMapState build() {
    //this makes provider global
    Hive.box('settings')
        .watch(key: MapSettings.alignFlutterMap)
        .listen((event) => state = event.value);
    return MapSettings.alignFlutterMap;
  }

  AlignFlutterMapState setNext() {
    switch (state ) {
      case AlignFlutterMapState.alignNever:
        state  = AlignFlutterMapState.alignPositionOnUpdateOnly;
        break;
        case AlignFlutterMapState.alignPositionOnUpdateOnly:
        state  = AlignFlutterMapState.alignDirectionAndPositionOnUpdate;
        break;
      case AlignFlutterMapState.alignDirectionOnUpdateOnly:
        state  = AlignFlutterMapState.alignDirectionAndPositionOnUpdate;
        break;
      case AlignFlutterMapState.alignDirectionAndPositionOnUpdate:
        state  = AlignFlutterMapState.alignNever;
        break;
      default:
        state  = AlignFlutterMapState.alignNever;
        break;
    }
    MapSettings.setAlignFlutterMap(state);
    return state;
  }
}
