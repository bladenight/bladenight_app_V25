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
import 'logger.dart';

const MethodChannel channel = MethodChannel('bladenightchannel');
const String flutterToWatch = 'flutterToWatch';
const String transferUserInfo = 'flutterToWatchTransferUserInfo';
const String transferApplicationContext =
    'flutterToWatchTransferApplicationContext';
const String updateApplicationContext = 'updateApplicationContext';
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
    channel.invokeMethod(flutterToWatch,
        {'method': 'updateRealtimeData', 'data': realTimeUpdate});
  }

  static setRoutePoints(RoutePoints? routePoints) {
    if (!Platform.isIOS) {
      return;
    }
    if (routePoints == null) {
      channel.invokeMethod(flutterToWatch,
          {'method': 'setRoutePoints', 'data': RoutePoints('-', <LatLng>[])});
    } else {
      channel.invokeMethod(flutterToWatch,
          {'method': 'setRoutePoints', 'data': routePoints.toJson()});
    }
  }

  static setIsLocationTracking(bool isTracking) {
    if (!Platform.isIOS) {
      return;
    }

    channel.invokeMethod(flutterToWatch,
        {'method': 'setIsLocationTracking', 'data': isTracking});
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
        flutterToWatch, {'method': 'setUserSpeed', 'data': uSpeed});
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

    channel.invokeMethod(
        transferUserInfo, {'method': 'phoneAppWillTerminate', 'data': ''});
  }

  static void updateFriends(String friendsJsonsArray) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, //transferApplicationContext
        {'method': 'updateFriends', 'data': friendsJsonsArray});
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
            BnLog.error(
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
            BnLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getEventDataFromFlutter',
                text: '$e');
          }
        }
        break;
      case 'getLocationIsTracking':
        print('getLocationIsTrackingFromFlutter received');
        try {
          SendToWatch.setIsLocationTracking(
              LocationProvider.instance.isTracking);
        } catch (e) {
          if (!kIsWeb) {
            BnLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getLocationIsTracking',
                text: '$e');
          }
        }
        break;
      case 'getFriendsDataFromFlutter':
        print('getFriendsDataFromFlutter received');
        try {
          LocationProvider.instance.refresh(forceUpdate: true);
        } catch (e) {
          if (!kIsWeb) {
            BnLog.error(
                className: 'watchCommunication_helper',
                methodName: 'getFriendsDataFromFlutter',
                text: '$e');
          }
        }
        break;
      case 'getRealtimeDataFromFlutter':
        print('getRealtimeDataFromFlutter received');
        try {
          LocationProvider.instance.getLastRealtimeData();
          if (LocationProvider.instance.realtimeUpdate != null) {
            SendToWatch.updateRealtimeData(
                LocationProvider.instance.realtimeUpdate.toJson());
          }
        } catch (e) {
          if (!kIsWeb) {
            BnLog.error(
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
