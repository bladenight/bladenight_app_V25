import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:synchronized/synchronized.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/server_connections.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/wamp/message_types.dart';
import '../models/realtime_update.dart';
import '../models/shake_hand_result.dart';
import 'bn_wamp_message.dart';
import 'http_overrides.dart';
import 'multiple_request_exception.dart';
import 'wamp_endpoints.dart';
import 'wamp_exception.dart';

///TODO add keepalive with on error reopen
enum WampConnectionState {
  unknown,
  connecting,
  connected,
  failed,
  offline,
  delayed,
  stopped
}

class WampV2 {
  static WampV2? _instance;

  WampV2._privateConstructor() {
    _init();
  }

  //instance factory
  factory WampV2() {
    _instance ??= WampV2._privateConstructor();
    return _instance!;
  }

  final internetConnChecker = InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(uri: WampV2.getServerUri()),
    ],
  );
  var _busyTimeStamp = DateTime.now();
  var _lock = Lock();
  WebSocketChannel? channel; //initialize a websocket channel
  static bool _hadShakeHands = false;
  static bool _wampStopped = false;
  static bool _startShakeHands = false;
  static int _startShakeHandsRetryCounter = 0;
  static bool _websocketIsConnected = false; //status of a websocket
  int _retryLimit = 3;

  bool _connectionErrorLogged = false;
  bool _lastConnectionStatus = false;

  bool get webSocketIsConnected => _websocketIsConnected;

  bool busy = false;
  final Map<int, BnWampMessage> calls = {};

  final Queue<BnWampMessage> queue = Queue();
  static Timer? _liveCycleTimer;
  StreamController<BnWampMessage>? _wampCallStreamController =
      StreamController<BnWampMessage>();
  final eventStreamController = StreamController<dynamic>.broadcast();
  final resultStreamController = StreamController<dynamic>.broadcast();
  final _wampConnectedStreamController = StreamController<bool>.broadcast();
  final realTimeUpdateStreamController =
      StreamController<RealtimeUpdate>.broadcast();

  StreamController<bool> get wampConnectedStreamController =>
      _wampConnectedStreamController;

  HashSet<int> get subscriptions => _subscriptions;
  final HashSet<int> _subscriptions = HashSet();
  StreamSubscription? _icCheckerSubscription;

  bool _isConnectedToInternet = true;

  void _init() {
    BnLog.info(text: 'Wamp Init', methodName: '_init', className: toString());
    if (!kIsWeb) {
      _icCheckerSubscription =
          internetConnChecker.onStatusChange.listen((InternetStatus result) {
        if (result == InternetStatus.connected) {
          _isConnectedToInternet = true;
          BnLog.debug(
              text: 'Wamp internet online',
              methodName: '_init',
              className: toString());
        } else {
          _isConnectedToInternet = false;
          BnLog.debug(
              text: 'Wamp internet offline',
              methodName: '_init',
              className: toString());
          _closeStream();
        }
      });
    }
    startWamp();
  }

  Future<WampConnectionState> _initWamp({bool force = false}) async {
    if (_wampStopped && !force) WampConnectionState.stopped;
    if (_websocketIsConnected) return WampConnectionState.connected;
    var startResult = false;
    _retryLimit = 3;
    try {
      startResult = await _lock.synchronized(() async {
        return await _startStream();
      }, timeout: const Duration(seconds: 5));
    } on TimeoutException catch (_) {
      BnLog.trace(text: 'Timeout _startStream');
      _lock = Lock();
    } catch (_) {
      BnLog.trace(text: '_startStream error $e', exception: e);
      _lock = Lock();
    }
    if (startResult == false) {
      return WampConnectionState.failed;
    }
    if (kIsWeb) {
      _hadShakeHands = true;
      return startResult == true
          ? WampConnectionState.connected
          : WampConnectionState.failed;
    }
    _shakeHands();
    return startResult == true
        ? WampConnectionState.connected
        : WampConnectionState.failed;
  }

  Future<WampConnectionState> refresh() async {
    BnLog.info(
        text: 'Wamp refresh after offline',
        methodName: 'refresh',
        className: toString());
    return _initWamp();
  }

  ///called from App and put to queue
  Future addToWamp<T>(BnWampMessage message) {
    if (_wampStopped) {
      startWamp();
    }
    _put(message);
    return message.completer.future;
  }

  void closeAndReconnect() async {
    _closeStream();
    /*await _lock.synchronized(() async {
      await _initWamp();
    });*/
  }

  ///called by [LocationProvider] in [LocationProvider.setToBackground] method
  void startWamp() {
    _wampStopped = false;
    _wampCallStreamController?.close();
    _wampCallStreamController = null;
    _wampCallStreamController = StreamController<BnWampMessage>();
    _initWamp();
    //_connLoop(); //
    _runner();
  }

  ///called by [LocationProvider] in [LocationProvider.setToBackground] method
  void stopWamp() {
    _wampStopped = true;
    _wampCallStreamController?.close();
    _wampCallStreamController = null;
    _closeStream();
    _liveCycleTimer?.cancel();
    _liveCycleTimer = null;
  }

  Future<void> _shakeHands() async {
    if (_startShakeHands == true) {
      return;
    }
    if (_hadShakeHands == false) {
      _startShakeHands = true;
      var shkRes = await ShakeHandResult.shakeHandsWamp();
      _startShakeHands = false;

      if (shkRes.rpcException != null) {
        _startShakeHandsRetryCounter++;
        BnLog.warning(
            text: 'shakeHands failed',
            methodName: '_shakeHands',
            className: toString());
        if (_startShakeHandsRetryCounter <= 3) {
          await Future.delayed(const Duration(seconds: 20));
          _shakeHands();
        } else {
          BnLog.warning(
              text: 'shakeHands failed after 3 attempts ${shkRes.rpcException}',
              methodName: '_shakeHands',
              className: toString());
        }
        return;
      } else {
        BnLog.info(
            text: 'shakeHands = ${shkRes.status}, minBuild:${shkRes.minBuild}',
            methodName: '_shakeHands',
            className: toString());
        _startShakeHandsRetryCounter = 0;
        _hadShakeHands = true;
        shakeHandAppOutdatedResult = shkRes;
        HiveSettingsDB.setAppOutDated(!shkRes.status);
      }
    }
  }

  void _put(BnWampMessage message) {
    var depreciatedCalls = <int, BnWampMessage>{};
    for (var call in calls.entries) {
      if (call.value.endpoint == message.endpoint) {
        depreciatedCalls[call.value.requestId] = call.value;
      }
    }
    for (var call in depreciatedCalls.entries) {
      call.value.completer.completeError(MultipleRequestException(
          'multiple request for ${call.value.endpoint}'));
      calls.remove(call.key);
    }

    calls[message.requestId] = message;
    if (_wampCallStreamController == null) {
      BnLog.warning(
          text: '_wampCallStreamController==null',
          methodName: 'put',
          className: toString());
    }
    _wampCallStreamController?.sink.add(message);
  }

  void _connLoop() async {
    _liveCycleTimer?.cancel();
    _liveCycleTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      while (_websocketIsConnected == false) {
        if (_isConnectedToInternet == false) {
          await Future.delayed(const Duration(milliseconds: 250));
          continue;
        }
        if (!_wampStopped) {
          BnLog.debug(text: 'initWamp by _connLoop');
          var _ = await _initWamp();
        }
      }
    });
  }

  void _runner() async {
    _wampCallStreamController?.stream.listen((message) async {
      runZonedGuarded(() async {
        queue.add(message);

        while (_websocketIsConnected == false) {
          // if (_liveCycleTimer != null && !_liveCycleTimer!.isActive) {
          var _ = await _initWamp(); //_connLoop();
          // }
          await Future.delayed(const Duration(milliseconds: 250));
        }
        if (DateTime.now().difference(_busyTimeStamp) >
            const Duration(milliseconds: 1000)) {
          busy = false;
        }
        if (busy == false) {
          busy = true;
          _busyTimeStamp = DateTime.now();
          while (busy) {
            if (queue.isEmpty) {
              busy = false;
              continue;
            }
            var nextMessage = queue.removeFirst();
            var timeDiff = DateTime.now().difference(nextMessage.dateTime);
            if (timeDiff > const Duration(seconds: 10)) {
              if (!message.completer.isCompleted) {
                message.completer.completeError(
                    WampException('WampV2_runner not started within 10 secs'));
              }
              calls.remove(message.requestId);
              busy = true;
              continue;
            }
            channel?.sink.add(message.getMessageAsJson);

            if (queue.isEmpty) {
              busy = false;
            }
          }
        }
      }, (error, stack) {
        if (!kIsWeb) {
          BnLog.error(text: 'Error in WampV2 Stream', exception: error);
        }
      });
    });
  }

  Future<bool> _startStream() async {
    //avoid long view of waiting for server
    await runZonedGuarded(() async {
      if (_websocketIsConnected) return true; //check if its already running

      if ((localTesting || useSelfCreatedCertificate) && !kIsWeb) {
        HttpOverrides.global = MyHttpOverrides();
      }
      final url = _getLink();
      channel = WebSocketChannel.connect(
        Uri.parse(url), //connect to a websocket
      );
      //await channel?.ready.timeout(const Duration(seconds: 1));
      var welcomeCompleter = Completer();
      channel!.stream.listen(
        (event) async {
          var wampMessage = json.decode(event) as List;
          var requestId = 0;
          if (wampMessage.length >= 2) {
            //workaround because server is sending requestId as "string"
            var strId = wampMessage[1].toString();
            requestId = int.parse(strId);
          }
          var wampMessageType =
              WampMessageTypeHelper.getMessageType(wampMessage[0]);

          if (wampMessageType == WampMessageType.welcome) {
            _websocketIsConnected = true;
            _wampConnectedStreamController.sink.add(true);
            _lastConnectionStatus = true;
            welcomeCompleter.complete(true);
            // [WELCOME, Session|id, Details|dict]
            return;
          }
          if (wampMessageType == WampMessageType.abort) {
            //[ABORT, Details|dict, Reason|uri, Arguments|list, ArgumentsKw|dict]
            _resetWampState();
            BnLog.info(text: 'Session aborted ${wampMessage[2]}');
            return;
          }
          if (wampMessageType == WampMessageType.goodbye) {
            //[GOODBYE, Details|dict, Reason|uri]
            _resetWampState();
            BnLog.info(text: 'Session closed with goodbye ${wampMessage[2]}');
            return;
          } else if (wampMessageType == WampMessageType.result) {
            _websocketIsConnected = true;
            // [RESULT, CALL.Request|id, Details|dict, YIELD.Arguments|list, YIELD.ArgumentsKw|dict]
            //BnLog.debug(text: 'channel result $wampMessage');
            var messageResult = wampMessage[2];
            //resultStreamController.add(messageResult.runtimeType);
            try {
              // realTimeUpdateStreamController.sink.add(RealtimeUpdateMapper.fromMap(messageResult));
            } catch (_) {}
            var cpl = calls[requestId]?.completer;
            cpl?.complete(messageResult);
            cpl = null;
            calls.remove(requestId);
            messageResult = null;
            return;
          } else if (wampMessageType == WampMessageType.error) {
            //   [ERROR, CALL, CALL.Request|id, Details|dict, Error|uri]
            var strId = wampMessage[2].toString();
            requestId = int.parse(strId);
            var cpl = calls[requestId]?.completer;
            cpl?.completeError(WampException(wampMessage[3]));
            calls.remove(wampMessage[2]);
            strId = '';
            cpl = null;
          } else if (wampMessageType == WampMessageType.subscribe) {
            // [SUBSCRIBE, Request|id, Options|dict, Topic|uri]
            BnLog.debug(text: 'subscribe $wampMessage');
            return;
          } else if (wampMessageType == WampMessageType.subscribed) {
            // [SUBSCRIBED, SUBSCRIBE.Request|id, Subscription|id]
            //    [33, 713845233, 5512315355]
            var messageResult = wampMessage[2];
            _subscriptions.add(wampMessage[2]);
            calls[requestId]?.completer.complete(messageResult);
            calls.remove(requestId);
            BnLog.debug(text: 'subscribed id:$messageResult');
            return;
          } else if (wampMessageType == WampMessageType.unsubscribe) {
            // [UNSUBSCRIBE, Request|id, SUBSCRIBED.Subscription|id]
            //  [34, 85346237, 5512315355]
            var messageResult = wampMessage[2];
            calls[requestId]?.completer.complete(messageResult);
            calls.remove(requestId);
            if (!kIsWeb) BnLog.debug(text: 'unsubscribe $wampMessage');
            return;
          } else if (wampMessageType == WampMessageType.unsubscribed) {
            //[UNSUBSCRIBED, UNSUBSCRIBE.Request|id]
            //[35, 85346237]
            var messageResult = wampMessage[1];
            subscriptions.remove(messageResult);
            calls[requestId]?.completer.complete(true);
            calls.remove(requestId);
            BnLog.debug(text: 'unsubscribed $wampMessage');
            return;
          } else if (wampMessageType == WampMessageType.publish) {
            //    [PUBLISH, Request|id, Options|dict, Topic|uri]
            var messageResult = wampMessage[3];
            calls[requestId]?.completer.complete(messageResult);
            calls.remove(requestId);
            BnLog.debug(text: 'publish $wampMessage');
            return;
          } else if (wampMessageType == WampMessageType.event) {
            // [EVENT, SUBSCRIBED.Subscription|id, PUBLISHED.Publication|id, Details|dict]
            //or     [EVENT, SUBSCRIBED.Subscription|id, PUBLISHED.Publication|id, Details|dict,
            // [36, 5512315355, 4429313566, {}]
            //         PUBLISH.Arguments|list, PUBLISH.ArgumentsKw|dict]
            //[36, 5512315355, 4429313566, {}, [], {"color": "orange", "sizes": [23, 42, 7]}]
            try {
              var messageResult = wampMessage[2];
              var id = int.parse(wampMessage[1]);
              _subscriptions.add(id);
              //realTimeUpdateStreamController.sink.add(RealtimeUpdateMapper.fromMap(messageResult));
              return;
            } catch (e) {
              BnLog.error(text: e.toString(), className: toString());
            }
            try {
              eventStreamController.sink.add(wampMessage[2]);
            } catch (e) {
              BnLog.error(text: e.toString(), className: toString());
            }
            BnLog.debug(text: 'event $wampMessage');
            return;
          } else {
            var typeId = wampMessage[0];
            BnLog.warning(
                text: 'WAMP unknown messageType typeId: $typeId $wampMessage');
          }
        },
        onDone: () {
          BnLog.trace(
              text: 'WampStream onDone',
              methodName: 'startStream',
              className: toString());
          _resetWampState();
        },
        onError: (err) async {
          BnLog.trace(
              text: 'WampStream onError ${err.toString()}',
              methodName: 'startStream',
              className: toString());
          if (_websocketIsConnected == false && _lastConnectionStatus == true) {
            _wampConnectedStreamController.sink.add(false);
            _lastConnectionStatus == false;
          }
          _websocketIsConnected = false;
          _hadShakeHands = false;
          if (_retryLimit > 0) {
            await Future.delayed(const Duration(milliseconds: 500));
            _retryLimit--;
            BnLog.trace(
                text: 'WampStream error ${err.toString()} restart Stream',
                methodName: 'startStream',
                className: toString());
            _startStream();
          } else {
            BnLog.trace(
                text: 'WampStream error ${err.toString()} too many fails',
                methodName: 'startStream',
                className: toString());
            if (!welcomeCompleter.isCompleted) {
              welcomeCompleter.completeError(e);
            }
            return false;
          }
        },
      );
      var res = await welcomeCompleter.future;
      _connectionErrorLogged = false;
      return res;
    }, (error, stack) {
      if (!_connectionErrorLogged) {
        BnLog.error(text: 'Wamp error close Wamp', exception: error);
        _connectionErrorLogged = true;
      }
      //_resetWampState();
    })?.catchError((error) {
      BnLog.error(text: 'Error wamp ->$error');
      _resetWampState();
      return false;
    });
    return true;
  }

  void _closeStream() {
    //disposes of the stream
    if (channel != null) {
      channel!.sink.close();
      channel = null;
    }
    _resetWampState();
  }

  void _resetWampState() {
    _lastConnectionStatus = false;
    _wampConnectedStreamController.sink.add(false);
    _websocketIsConnected = false;
    _hadShakeHands = false;
    _startShakeHands = false;
    _subscriptions.clear();
  }

  String _getLink() {
    String link = '';
    if (HiveSettingsDB.useCustomServer) {
      link = HiveSettingsDB.customServerAddress;
    } else if ((kDebugMode && localTesting) && !kIsWeb) {
      link = Platform.isAndroid
          ? defaultTestWampAdressAndroid
          : defaultTestWampAdressOther; //defaultTestWampAddressOther;
    } else if (kIsWeb) {
      link = defaultWampClientAux;
    } else {
      link = defaultWampAddress;
    }
    Uri linkUri = Uri.parse(link);
    actualServerAndPortUri = linkUri;
    var isSecure = linkUri.scheme == 'wss' || linkUri.scheme == 'https';
    var hostAppend = isSecure ? 's' : '';
    var actualServerHost =
        'http$hostAppend://${linkUri.host}:${linkUri.port}/www/';

    BnLog.trace(
        className: 'Wamp_V2',
        text: 'Will open new Session http$hostAppend://${linkUri.host}',
        methodName: 'getSession');

    actualHttpSServerHost = actualServerHost;
    return link;
  }

  _getInitialRealTimeData() async {
    var callList = calls.entries.toList();
    for (var item in callList) {
      if (item.value.endpoint == WampEndpoint.getrealtimeupdate) {
        try {
          calls.remove(item.key);
        } catch (_) {}
      }
    }
  }

  static Uri getServerUri() {
    String link = '';
    if (HiveSettingsDB.useCustomServer) {
      link = HiveSettingsDB.customServerAddress;
    } else if ((kDebugMode && localTesting) && !kIsWeb) {
      link = Platform.isAndroid
          ? defaultTestWampAdressAndroid
          : defaultTestWampAdressOther; //defaultTestWampAddressOther;
    } else if (kIsWeb) {
      link = defaultWampClientAux;
    } else {
      link = defaultWampAddress;
    }
    Uri linkUri = Uri.parse(link);
    return linkUri;
  }
}
