import 'package:dart_mappable/dart_mappable.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../models/event.dart';
import '../models/moving_point.dart';
import '../models/route.dart';
import '../models/watchEvent.dart';
import '../providers/active_event_notifier_provider.dart';
import '../providers/location_provider.dart';
import 'preferences_helper.dart';

const MethodChannel channel = MethodChannel('bladenightchannel');
const String flutterToWatch = 'flutterToWatch';
const String transferUserInfo = 'flutterToWatchTransferUserInfo';
const String transferApplicationContext =
    'flutterToWatchTransferApplicationContext';
const String updateApplicationContext =
    'updateApplicationContext';
const String updateEventMethod = 'updateEvent';

class SendToWatch {
  static updateEvent(Event event) {
    if (!Platform.isIOS) {
      return;
    }
    //convert to WatchEventModel included translations
    var watchEvent = WatchEvent.copyFrom(event).toJson();
    channel.invokeMethod(
        flutterToWatch, {'method': updateEventMethod, 'data': watchEvent});
  }

  static updateRealtimeData(String? realTimeUpdate) {
    if (!Platform.isIOS) {
      return;
    }
    if (kDebugMode) {
      channel.invokeMethod(flutterToWatch,
          {'method': 'updateRealtimeData', 'data': realTimeUpdate});
    } else {
      channel.invokeMethod(transferApplicationContext,
          {'method': 'updateRealtimeData', 'data': realTimeUpdate});
    }
  }

  static setRoutePoints(RoutePoints? routePoints) {
    if (!Platform.isIOS) {
      return;
    }
    if (routePoints == null) {
      channel.invokeMethod(flutterToWatch,
          {'method': 'setRoutePoints', 'data': RoutePoints('-', <LatLng>[])});
    } else {
      channel.invokeMethod('flutterToWatch',
          {'method': 'setRoutePoints', 'data': routePoints.toJson()});
    }
  }

  static setIsLocationTracking(bool isTracking) {
    if (!Platform.isIOS) {
      return;
    }
    if (kDebugMode) {
      channel.invokeMethod(flutterToWatch,
          {'method': 'setIsLocationTracking', 'data': isTracking});
    } else {
      channel.invokeMethod(transferApplicationContext,
          {'method': 'setIsLocationTracking', 'data': isTracking});
    }
  }

  static setElapsedDistanceLength(double distance) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(flutterToWatch,
        {'method': 'setElapsedDistanceLength', 'data': distance});
  }

  static setRunningLength(double rlength) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, {'method': 'setRunningLength', 'data': rlength});
  }

  static setUserSpeed(String uSpeed) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(
        transferUserInfo, {'method': 'setUserSpeed', 'data': uSpeed});
  }

  static void updateUserLocationData(MovingPoint userMovingPoint) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(flutterToWatch,
        {'method': 'updateUserLocationData', 'data': userMovingPoint.toJson()});
  }

  static void phoneAppWillTerminate() {
    if (!Platform.isIOS) {
      return;
    }
    if (kDebugMode) {
      //no userdata and appcontext in debug transfer
      channel.invokeMethod(
          transferUserInfo, {'method': 'phoneAppWillTerminate', 'data': ''});
    } else {
      channel.invokeMethod(
          transferUserInfo, {'method': 'phoneAppWillTerminate', 'data': ''});
    }
  }

  static void updateFriends(String friendsJsonsArray) {
    if (!Platform.isIOS) {
      return;
    }
    if (kDebugMode) {
      //no userdata and appcontext in debug transfer
      channel.invokeMethod(transferUserInfo,
          {'method': 'updateFriends', 'data': friendsJsonsArray});
    } else {
      channel.invokeMethod(
          transferUserInfo, //transferApplicationContext
          {'method': 'updateFriends', 'data': friendsJsonsArray});
    }
  }
}

Future<void> initFlutterChannel() async {
  channel.setMethodCallHandler((call) async {
    // Receive data from Native
    switch (call.method) {
      case 'sendNavToggleToFlutter':
        print('sendNavToggleToFlutter received');
        try {
          ProviderContainer()
              .read(locationProvider)
              .toggleProcessionTracking(userIsParticipant: true);
        } catch (e) {
          if (!kIsWeb) {
            FLog.error(
                className: 'watchCommunication_helper',
                methodName: 'sendNavToggleToFlutter',
                text: '$e');
          }
        }
        break;
      case 'getEventDataFromFlutter':
        print('getEventDataFromFlutter received');
        try {
          ProviderContainer()
              .read(activeEventProvider)
              .refresh(forceUpdate: true);
          ProviderContainer().read(locationProvider).refresh(forceUpdate: true);
        } catch (e) {
          if (!kIsWeb) {
            FLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getEventDataFromFlutter',
                text: '$e');
          }
        }
        break;
      case 'getLocationIsTracking':
        print('getLocationIsTrackingFromFlutter received');
        try {
          var istr = ProviderContainer().read(isTrackingProvider);
          SendToWatch.setIsLocationTracking(istr);
        } catch (e) {
          if (!kIsWeb) {
            FLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getLocationIsTracking',
                text: '$e');
          }
        }
        break;
      case 'getFriendsDataFromFlutter':
        print('getFriendsDataFromFlutter received');
        try {
          var friendList = await PreferencesHelper.getFriendsFromPrefs();
          var friendListAsJson = MapperContainer.globals.toJson(friendList);
          print('send friends to watch $friendListAsJson');
          SendToWatch.updateFriends(friendListAsJson);
        } catch (e) {
          if (!kIsWeb) {
            FLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getFriendsDataFromFlutter',
                text: '$e');
          }
        }
        break;
      default:
        break;
    }
  });
}
//}
