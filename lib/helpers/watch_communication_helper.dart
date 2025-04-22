import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../models/event.dart';
import '../models/route.dart';
import '../models/user_location_point.dart';
import '../models/watch_event.dart';
import '../providers/active_event_provider.dart';
import '../providers/is_tracking_provider.dart';
import '../providers/location_provider.dart';
import 'enums/tracking_type.dart';
import 'logger/logger.dart';

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

  /*static setUserSpeed(String uSpeed) {
    if (!Platform.isIOS) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, {'method': 'setUserSpeed', 'data': uSpeed});
  }*/

  static UserLocationPoint _lastPoint =
      UserLocationPoint.userLocationPointEmpty();

  static void updateUserLocationData(UserLocationPoint userLocationPoint) {
    if (!Platform.isIOS) {
      return;
    }
    if (_lastPoint.hashCode == userLocationPoint.hashCode) {
      return; //no update if equal locations
    }
    _lastPoint = userLocationPoint;
    channel.invokeMethod(flutterToWatch, {
      'method': 'updateUserLocationData',
      'data': userLocationPoint.toJson()
    });
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

  static void updateRunningRoute(List<LatLng> rtData) {
    if (!Platform.isIOS) {
      return;
    }
    try {
      var routePoints = RoutePoints('procession', rtData);
      channel.invokeMethod(flutterToWatch,
          {'method': 'updateRunningRoute', 'data': routePoints.toJson()});
    } catch (e) {
      BnLog.error(text: 'Failed to send update running route $e');
    }
  }
}

Future<void> initWatchFlutterChannel() async {
  channel.setMethodCallHandler((call) async {
    // Receive data from Native
    switch (call.method) {
      case 'sendNavToggleToFlutter':
        //print('sendNavToggleToFlutter received');
        try {
          ProviderContainer()
              .read(isTrackingProvider.notifier)
              .toggleTracking(TrackingType.userParticipating);
        } catch (e) {
          BnLog.error(
              className: 'watchCommunication_helper',
              methodName: 'sendNavToggleToFlutter',
              text: '$e');
        }
        break;
      case 'getEventDataFromFlutter':
        //print('getEventDataFromFlutter received');
        try {
          ActiveEventProvider().refresh(forceUpdate: true);
          LocationProvider().refreshRealtimeData(forceUpdate: true);
        } catch (e) {
          BnLog.error(
              className: 'watchCommunication_helper',
              methodName: 'getEventDataFromFlutter',
              text: '$e');
        }
        break;
      case 'getLocationIsTracking':
        //print('getLocationIsTrackingFromFlutter received');
        try {
          SendToWatch.setIsLocationTracking(
              ProviderContainer().read(isTrackingProvider));
        } catch (e) {
          BnLog.error(
              className: 'watchCommunication_helper',
              methodName: 'getLocationIsTracking',
              text: '$e');
        }
        break;
      case 'getFriendsDataFromFlutter':
        //print('getFriendsDataFromFlutter received');
        try {
          LocationProvider().refreshRealtimeData(forceUpdate: true);
        } catch (e) {
          BnLog.error(
              className: 'watchCommunication_helper',
              methodName: 'getFriendsDataFromFlutter',
              text: '$e');
        }
        break;
      case 'getRealtimeDataFromFlutter':
        //print('getRealtimeDataFromFlutter received');
        try {
          var rtData = ProviderContainer().read(realtimeDataProvider);
          if (rtData != null) {
            SendToWatch.updateRealtimeData(rtData.toJson());
            rtData = null;
          }
        } catch (e) {
          BnLog.error(
              className: 'watchCommunication_helper',
              methodName: 'getFriendsDataFromFlutter',
              text: '$e');
        }
        break;
      default:
        break;
    }
  });
}
//}
