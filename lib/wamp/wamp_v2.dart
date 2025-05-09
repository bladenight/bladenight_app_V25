import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/server_connections.dart';
import '../helpers/enums/tracking_type.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger/logger.dart';
import '../helpers/wamp/message_types.dart';
import '../models/event.dart';
import '../models/realtime_update.dart';
import '../models/shake_hand_result.dart';
import '../providers/location_provider.dart';
import 'bn_wamp_message.dart';
import 'http_overrides.dart';
import 'wamp_exception.dart';

enum WampConnectionState {
  unknown,
  connecting,
  connected,
  failed,
  offline,
  delayed,
  disconnected,
  stopped
}

///State for network_connection_provider
enum WampConnectedState { disconnected, connected }

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

  var _busyTimeStamp = DateTime.now();
  StreamSubscription<dynamic>? _channelStreamLister;
  var _lock = Lock();
  WebSocketChannel? _channel; //initialize a websocket channel
  static bool _hadShakeHands = false;

  /// Stop wamp if only tracking
  static bool _wampStopped = false;
  static bool _startShakeHands = false;
  static int _startShakeHandsRetryCounter = 0;
  static WampConnectionState _wampConnectionState = WampConnectionState.unknown;

  //static bool _websocketIsConnected = false; //status of a websocket
  int _retryLimit = 3;

  bool _connectionErrorLogged = false;
  bool _lastConnectionStatus = false;

  bool get webSocketIsConnected =>
      _wampConnectionState == WampConnectionState.connected;

  bool busy = false;
  final Map<int, BnWampMessage> calls = {};

  final Queue<BnWampMessage> queue = Queue();
  static Timer? _liveCycleTimer;
  final StreamController<BnWampMessage> _messageCallStreamController =
      StreamController<BnWampMessage>();
  final eventStreamController = StreamController<dynamic>.broadcast();
  final resultStreamController = StreamController<dynamic>.broadcast();
  final _wampConnectedStreamController =
      StreamController<WampConnectedState>.broadcast();
  final realTimeUpdateStreamController =
      StreamController<RealtimeUpdate>.broadcast();
  final eventUpdateStreamController = StreamController<Event>.broadcast();

  StreamController<WampConnectedState> get wampConnectedStreamController =>
      _wampConnectedStreamController;

  HashSet<int> get subscriptions => _subscriptions;
  final HashSet<int> _subscriptions = HashSet();

  DateTime _lastPutMessage = DateTime.now();
  DateTime _lastWampStreamLifeSign = DateTime.now();

  void _init() {
    BnLog.info(text: 'Wamp init', methodName: '_init', className: toString());
    if (!kIsWeb) {}
    startWamp();
    _messageQueueRunner();
  }

  Future<WampConnectionState> _initWamp({bool force = false}) async {
    BnLog.verbose(
        text: '_initWamp state $_wampConnectionState',
        methodName: 'startWamp',
        className: toString());
    if (_wampStopped && !force) WampConnectionState.disconnected;
    if (_wampConnectionState == WampConnectionState.connecting) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    if (_wampConnectionState == WampConnectionState.connected) {
      return WampConnectionState.connected;
    }

    var startResult = false;
    _retryLimit = 3;
    try {
      startResult = await _lock.synchronized(() async {
        return await _startStream();
      }, timeout: const Duration(seconds: 5));
    } on TimeoutException catch (_) {
      BnLog.verbose(text: 'Timeout _startStream');
    } catch (ex) {
      BnLog.error(text: 'InitWamp error:$e ex:${ex.toString()}');
    } finally {
      if (_wampConnectionState != WampConnectionState.connected) {
        //_wampConnectionState = WampConnectionState.failed;
      }
      _lock = Lock();
    }
    if (startResult == false) {
      return _wampConnectionState;
    }
    if (kIsWeb) {
      _hadShakeHands = true;
      return startResult == true
          ? WampConnectionState.connected
          : WampConnectionState.failed;
    }
    await _shakeHands();
    BnLog.verbose(
        text: 'Wamp start result $startResult',
        methodName: '_initWamp',
        className: toString());
    return startResult == true
        ? WampConnectionState.connected
        : WampConnectionState.failed;
  }

  Future<WampConnectionState> refresh() async {
    BnLog.debug(
        text:
            'Wamp refresh called state $_wampConnectionState - will _initWamp',
        methodName: 'refresh',
        className: toString());
    return _initWamp();
  }

  void closeWamp() async {
    _closeStream();
    _resetWampState();
  }

  ///called by [LocationProvider] in [LocationProvider.setToBackground] method
  Future<WampConnectionState> startWamp() async {
    if (_wampConnectionState == WampConnectionState.connected &&
        _liveCycleTimer != null &&
        _liveCycleTimer!.isActive) {
      return WampConnectionState.connected;
    }
    BnLog.info(
        text: 'Start WAMP connection',
        methodName: 'startWamp',
        className: toString());
    _wampStopped = false;
    return _startConnectionMonitoring();
  }

  ///called by [LocationProvider] in [LocationProvider.setToBackground] method
  void stopWamp() {
    BnLog.verbose(
        text: 'stopWamp', methodName: 'stopWamp', className: toString());

    _wampStopped = true;
    _closeStream();
    _resetWampState();
    /*_liveCycleTimer?.cancel();
    _liveCycleTimer = null;*/
  }

  var shakeHandsLock = Lock();

  Future<void> _shakeHands() async {
    if (_startShakeHands == true) {
      return;
    }
    try {
      shakeHandsLock
          .synchronized(() async {
            if (_hadShakeHands == false) {
              _startShakeHands = true;
              var shkRes = await ShakeHandResult.shakeHandsWamp();
              _startShakeHands = false;

              if (shkRes.rpcException != null) {
                _startShakeHandsRetryCounter++;
                BnLog.verbose(
                    text:
                        'shakeHands failed retry$_startShakeHandsRetryCounter',
                    methodName: '_shakeHands',
                    className: toString());
                if (_startShakeHandsRetryCounter <= 3) {
                  await Future.delayed(const Duration(seconds: 3));
                  BnLog.verbose(
                      text:
                          'shakeHands failed retry$_startShakeHandsRetryCounter',
                      methodName: '_shakeHands',
                      className: toString());

                  _shakeHands();
                } else {
                  BnLog.warning(
                      text:
                          'shakeHands failed after 3 attempts ${shkRes.rpcException}  wait 15 secs',
                      methodName: '_shakeHands',
                      className: toString());
                  _startShakeHandsRetryCounter = 0;
                }
                return;
              } else {
                BnLog.info(
                    text:
                        'shakeHands = ${shkRes.status}, minBuild:${shkRes.minBuild}',
                    methodName: '_shakeHands',
                    className: toString());
                _startShakeHandsRetryCounter = 0;
                _hadShakeHands = true;
                shakeHandAppOutdatedResult = shkRes;
                HiveSettingsDB.setAppOutDated(!shkRes.status);
                HiveSettingsDB.setServerVersion(shkRes.serverVersion);
              }
            }
          })
          .timeout(Duration(seconds: 5))
          .catchError((error) {
            BnLog.warning(text: 'Shakehands not successfully $error');
          });
    } catch (ex) {
      BnLog.error(
          text: 'Wamp shakehands error $ex',
          methodName: '_shakehands',
          className: toString());
    }
  }

  ///called from App and put to queue
  Future addToWamp<T>(BnWampMessage message) async {
    _put(message);
    return message.completer.future;
    /*} else {
      return message.completer
          .complete(WampException(WampExceptionReason.wampStopped));
    }*/
    //});
  }

  Future<WampConnectionState> _startConnectionMonitoring() async {
    _liveCycleTimer?.cancel();
    _liveCycleTimer =
        Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      var diffLastPutMessage = DateTime.now().difference(_lastPutMessage);
      if (subscriptions.isEmpty && diffLastPutMessage.inMinutes > 3) {
        BnLog.info(
            text:
                'no new Messages since ${_lastPutMessage.toIso8601String()} / ${diffLastPutMessage.inSeconds}  stop wamp by _connLoop');
        stopWamp();
        return;
      }

      var diffWampLastLifeSign =
          DateTime.now().difference(_lastWampStreamLifeSign);
      if (diffWampLastLifeSign.inMinutes > 2) {
        BnLog.info(
            text:
                'Close wamp by _connLoop. LastLifeSign = ${_lastWampStreamLifeSign.toIso8601String()} ');
        //_lastWampStreamLifeSign=DateTime.now();//reset
        closeWamp();
      }

      if (_wampConnectionState != WampConnectionState.connected &&
          !_wampStopped &&
          LocationProvider().isInBackground &&
          LocationProvider().trackingType != TrackingType.onlyTracking) {
        BnLog.debug(text: 'initWamp by _connLoop');
        await _connectToWamp();
      }
    });

    return _connectToWamp();
  }

  Future<WampConnectionState> _connectToWamp() async {
    var connState = await _initWamp();
    BnLog.verbose(
        text: 'startWamp connState = $connState',
        methodName: 'startWamp',
        className: toString());
    return connState;
  }

  ///Put messages to queue
  ///removing double requests
  ///remove calls older than 60 secs
  void _put(BnWampMessage message) {
    _messageCallStreamController.sink.add(message);
    _lastPutMessage = DateTime.now();
  }

  ///loop to add messages to wamp and request results
  ///clears outdated messages
  void _messageQueueRunner() async {
    _messageCallStreamController.stream.listen((message) async {
      runZonedGuarded(() async {
        var outdatedCalls = <int, BnWampMessage>{};
        for (var call in calls.entries) {
          if (call.value.endpoint == message.endpoint) {
            outdatedCalls[call.value.requestId] = call.value;
          }
          var age = DateTime.now().difference(call.value.dateTime);
          if (age > Duration(seconds: 60)) {
            outdatedCalls[call.value.requestId] = call.value;
          }
        }
        for (var call in outdatedCalls.entries) {
          if (!call.value.completer.isCompleted) {
            queue.removeWhere((x) => x.message == call.value);
            call.value.completer
                .completeError(WampException(WampExceptionReason.outdated));
            calls.remove(call.key);
          }
        }
        calls[message.requestId] = message;

        queue.add(message);
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
                    WampException(WampExceptionReason.timeout10sec));
              }
              calls.remove(message.requestId);
              busy = true;
              continue;
            }
            _channel?.sink.add(message.getMessageAsJson);

            if (queue.isEmpty) {
              busy = false;
            }
          }
        }
      }, (error, stack) {
        BnLog.error(text: 'Error in WampV2 Stream', exception: error);
      });
    });
  }

  ///WampStream and WampHandler
  Future<bool> _startStream() async {
    await runZonedGuarded(() async {
      if (_wampConnectionState == WampConnectionState.connected) {
        return true; //check if already running
      }
      _wampConnectionState = WampConnectionState.connecting;
      if ((localTesting || useSelfCreatedCertificate) && !kIsWeb) {
        HttpOverrides.global = MyHttpOverrides();
      }
      final url = _getLink().replaceAll('\r', '').replaceAll('\n', '');

      var channel = WebSocketChannel.connect(
        Uri.parse(url), //connect to a websocket
      );

      try {
        await channel.ready;
        _channel = channel;
      } on SocketException catch (e) {
        _channel = null;
        _wampConnectionState = WampConnectionState.failed;
        BnLog.error(text: 'error SocketException $e', exception: e);
        return false;
      } on WebSocketChannelException catch (e) {
        _channel = null;
        _wampConnectionState = WampConnectionState.failed;
        BnLog.error(
            text: 'error WebsocketChannel start stream $e', exception: e);
        return false;
      }
      var welcomeCompleter = Completer();
      _channelStreamLister = _channel!.stream.listen(
        (event) async {
          _lastWampStreamLifeSign = DateTime.now();
          _wampConnectedStreamController.sink.add(WampConnectedState.connected);
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
            _wampConnectionState = WampConnectionState.connected;
            _wampConnectedStreamController.sink
                .add(WampConnectedState.connected);
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
            _wampConnectionState = WampConnectionState.connected;
            // [RESULT, CALL.Request|id, Details|dict, YIELD.Arguments|list, YIELD.ArgumentsKw|dict]
            //BnLog.debug(text: 'channel result $wampMessage');
            var messageResult = wampMessage[2];
            //resultStreamController.add(messageResult.runtimeType);
            try {
              // realTimeUpdateStreamController.sink.add(RealtimeUpdateMapper.fromMap(messageResult));
            } catch (_) {}
            var cpl = calls[requestId]?.completer;
            if (cpl != null && !cpl.isCompleted) {
              cpl.complete(messageResult);
            }
            cpl = null;
            calls.remove(requestId);
            messageResult = null;
            return;
          } else if (wampMessageType == WampMessageType.error) {
            //   [ERROR, CALL, CALL.Request|id, Details|dict, Error|uri]
            var strId = wampMessage[2].toString();
            requestId = int.parse(strId);
            var cpl = calls[requestId]?.completer;
            if (cpl != null && !cpl.isCompleted) {
              cpl.completeError(WampException(
                  WampExceptionReason.wampMessageError,
                  message: wampMessage[3]));
            }
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
              var payload = wampMessage[2];
              var id = int.parse(wampMessage[1]);
              if (id == 12345678 && wampMessage.length >= 3) {
                //new event triggered
                try {
                  var event = EventMapper.fromMap(payload);
                  eventUpdateStreamController.sink.add(event);
                } catch (e) {
                  BnLog.error(text: 'error event decoding wampV2');
                }
                return;
              }
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
          BnLog.verbose(
              text: 'WampStream onDone',
              methodName: 'startStream',
              className: toString());
          _resetWampState();
        },
        onError: (err) async {
          BnLog.verbose(
              text: 'WampStream onError ${err.toString()}',
              methodName: 'startStream',
              className: toString());
          if (_wampConnectionState != WampConnectionState.connected &&
              _lastConnectionStatus == true) {
            _wampConnectedStreamController.sink
                .add(WampConnectedState.disconnected);
            _lastConnectionStatus == false;
          }
          _wampConnectionState = WampConnectionState.disconnected;
          _hadShakeHands = false;
          if (_retryLimit > 0) {
            await Future.delayed(const Duration(milliseconds: 500));
            _retryLimit--;
            BnLog.verbose(
                text: 'WampStream error ${err.toString()} restart Stream',
                methodName: 'startStream',
                className: toString());
            // _startStream(); perhaps memory leak
          } else {
            BnLog.verbose(
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
        BnLog.error(text: 'Wamp error closed connection', exception: error);
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

  void _closeStream() async {
    //disposes of the stream
    await _channelStreamLister?.cancel();
    _channelStreamLister = null;
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }
  }

  ///Reset wamp so it can reconnect - close stream before
  void _resetWampState() {
    _lastConnectionStatus = false;
    _wampStopped = false;
    _wampConnectedStreamController.sink.add(WampConnectedState.disconnected);
    _wampConnectionState = WampConnectionState.disconnected;
    _hadShakeHands = false;
    _startShakeHands = false;
    _subscriptions.clear();
  }

  String _getLink() {
    String link = '';
    if (HiveSettingsDB.useCustomServer) {
      link = HiveSettingsDB.customServerAddress;
    } else if ((localTesting || remoteTesting) && !kIsWeb) {
      link = Platform.isAndroid
          ? remoteTesting
              ? remoteTestWampAddressAndroid
              : localTestWampAddress
          : remoteTesting
              ? remoteTestWampAddressOther
              : localTestWampAddress;
    } else if ((localTesting || remoteTesting) && kIsWeb) {
      link = remoteTesting ? remoteTestWampAddressAux : localTestWampAddressAux;
    } else if (kIsWeb) {
      link = defaultWampAddressAux;
    } else {
      link = defaultWampAddress;
    }
    Uri linkUri = Uri.parse(link);
    actualServerAndPortUri = linkUri;
    var isSecure = linkUri.scheme == 'wss' || linkUri.scheme == 'https';
    var hostAppend = isSecure ? 's' : '';
    var actualServerHost =
        'http$hostAppend://${linkUri.host}:${linkUri.port}/www/';

    BnLog.verbose(
        className: 'Wamp_V2',
        text: 'Will open new Session http$hostAppend://${linkUri.host}',
        methodName: 'getSession');

    actualHttpSServerHost = actualServerHost;
    return link;
  }

  Uri getServerUri() {
    String link = _getLink();
    Uri linkUri = Uri.parse(link);
    return linkUri;
  }
}
