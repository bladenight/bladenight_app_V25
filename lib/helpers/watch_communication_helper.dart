import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';
import '../models/event.dart';
import '../models/moving_point.dart';
import '../models/route.dart';
import '../providers/active_event_notifier_provider.dart';
import '../providers/location_provider.dart';
import 'timeconverter_helper.dart';

const MethodChannel channel = MethodChannel('bladenightchannel');
const String flutterToWatch = 'flutterToWatch';
const String transferUserInfo = 'flutterToWatchTransferUserInfo';
const String transferApplicationContext =
    'flutterToWatchTransferApplicationContext';

class SendToWatch {
  static updateEvent(Event event) {
    if (kIsWeb) {
      return;
    }
    setConfirmationStatus(event.status == EventStatus.confirmed);
    eventRouteName(event.routeName);
    var dateString = DateFormatter(Localize.current)
        .getLocalDayDateTimeRepresentation(event.getUtcIso8601DateTime);
    eventStartDate(dateString);
    var eventStateText =
        '${Localize.current.status}: ${Intl.select(event.status, {
          EventStatus.pending: Localize.current.pending,
          EventStatus.confirmed: Localize.current.confirmed,
          EventStatus.cancelled: Localize.current.canceled,
          EventStatus.noevent: Localize.current.noEvent,
          EventStatus.running: Localize.current.running,
          EventStatus.finished: Localize.current.finished,
          'other': Localize.current.unknown
        })}';
    eventStatusText(eventStateText);
  }

  static eventRouteName(String routeName) {
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, {'method': 'setActiveEventName', 'data': routeName});
  }

  static eventStartDate(String startDate) {
    if (kIsWeb) {
      return;
    }
    if (kDebugMode) {
      //not userdata and appcontext in debug transfer
      channel.invokeMethod(
          flutterToWatch, {'method': 'eventStartDate', 'data': startDate});
    } else {
      channel.invokeMethod(transferUserInfo,
          {'method': 'setActiveEventDate', 'data': startDate});
    }
  }

  static eventStatusText(String statusText) {
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(flutterToWatch,
        {'method': 'setActiveEventStatusText', 'data': statusText});
  }

  static setConfirmationStatus(bool status) {
    channel.invokeMethod(
        flutterToWatch, {'method': 'setConfirmationStatus', 'data': status});
  }

  static updateRealtimeData(String? realTimeUpdate) {
    if (kIsWeb) {
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
    if (kIsWeb) {
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
    if (kIsWeb) {
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
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(flutterToWatch,
        {'method': 'setElapsedDistanceLength', 'data': distance});
  }

  static setRunningLength(double rlength) {
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, {'method': 'setRunningLength', 'data': rlength});
  }

  static setUserSpeed(String uSpeed) {
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(
        flutterToWatch, {'method': 'setUserSpeed', 'data': uSpeed});
  }

  static void updateUserLocationData(MovingPoint userMovingPoint) {
    if (kIsWeb) {
      return;
    }
    channel.invokeMethod(flutterToWatch,
        {'method': 'updateUserLocationData', 'data': userMovingPoint.toJson()});
  }

  static void phoneAppWillTerminate() {
    if (kIsWeb) {
      return;
    }
    if (kDebugMode) {
      //no userdata and appcontext in debug transfer
      channel.invokeMethod(
          flutterToWatch, {'method': 'phoneAppWillTerminate', 'data': ''});
    } else {
      channel.invokeMethod(
          transferUserInfo, {'method': 'phoneAppWillTerminate', 'data': ''});
    }
  }

  static void updateFriends(String friendsJsonsArray) {
    if (kIsWeb) {
      return;
    }
    if (kDebugMode) {
      //no userdata and appcontext in debug transfer
      channel.invokeMethod(flutterToWatch,
          {'method': 'updateFriends', 'data': friendsJsonsArray});
    } else {
      channel.invokeMethod(transferApplicationContext,
          {'method': 'updateFriends', 'data': friendsJsonsArray});
    }
  }
}

//class ReceiveFromWatch {
/* static final ReceiveFromWatch instance = ReceiveFromWatch._();

  ReceiveFromWatch._() {
    _initFlutterChannel();
  }*/

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
      default:
        break;
    }
  });
}
//}
