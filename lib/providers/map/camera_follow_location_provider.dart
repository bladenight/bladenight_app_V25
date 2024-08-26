import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/follow_location_state.dart';

part 'camera_follow_location_provider.g.dart';

@Riverpod(keepAlive: false)
class CameraFollowLocation extends _$CameraFollowLocation {
  @override
  CameraFollow build() {
    Hive.box('settings')
        .watch(key: MapSettings.cameraFollowKey)
        .listen((event) => state = CameraFollow.values.firstWhere((element) {
              return event.value == element.index;
            }));
    return MapSettings.cameraFollow;
  }

  CameraFollow setNext() {
    switch (state) {
      case CameraFollow.followOff:
        state = CameraFollow.followMe;
        //startFollowingMeLocation();
        //showToast(message: Localize.of(context).mapFollowLocation);
        break;
      case CameraFollow.followMe:
        state = CameraFollow.followMeStopped;
        //stopFollowingLocation();
        //showToast(message: Localize.of(context).mapFollowStopped);
        break;
      case CameraFollow.followMeStopped:
        state = CameraFollow.followTrain;
        //startFollowingTrainHead(controller);
        //showToast(message: Localize.of(context).mapFollowTrain);
        break;
      case CameraFollow.followTrain:
        state = CameraFollow.followTrainStopped;
        //stopFollowingLocation();
        //showToast(message: Localize.of(context).mapFollowTrainStopped);
        break;
      case CameraFollow.followTrainStopped:
        state = CameraFollow.followOff;
        //_moveMapToDefault(controller);
        //showToast(message: Localize.of(context).mapToStartNoFollowing);
        break;
      default:
        state = CameraFollow.followOff;
        /*if (locationSubscription != null) {
          stopFollowingLocation();
        } else {
          startFollowingMeLocation();
        }*/
        break;
    }
    MapSettings.setCameraFollow(state);
    return state;
  }
}
