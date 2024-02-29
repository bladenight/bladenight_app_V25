import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import 'wamp_error.dart';

enum WampConnectionState { unknown, connecting, connected, failed, offline }

class WampV2 {
  static final WampV2 instance = WampV2._();

  var _busyTimeStamp = DateTime.now();

  WebSocketChannel? channel; //initialize a websocket channel
  static bool _isConnecting = false;
  static bool _hadShakeHands = false;
  static bool _startShakeHands = false;
  static int _startShakeHandsRetryCounter = 0;

  bool _connectionErrorLogged = false;
  bool _lastConnectionStatus = false;

  bool get webSocketIsConnected => _isWebsocketRunning;
  bool _isWebsocketRunning = false; //status of a websocket
  bool busy = false;
  final Map<int, BnWampMessage> calls = {};
  int _retryLimit = 3;
  Queue<BnWampMessage> queue = Queue();
  var streamController = StreamController<BnWampMessage>.broadcast();

  var eventStreamController = StreamController<dynamic>.broadcast();
  var resultStreamController = StreamController<dynamic>.broadcast();

  StreamController<bool> get connectedStreamController =>
      _connectedStreamController;

  final _connectedStreamController = StreamController<bool>.broadcast();

  StreamController<RealtimeUpdate?> get realTimeUpdateStreamController =>
      _realTimeUpdateStreamController;
  final _realTimeUpdateStreamController =
      StreamController<RealtimeUpdate?>.broadcast();

  HashSet<int> get subscriptions => _subscriptions;
  final HashSet<int> _subscriptions = HashSet();

  WampV2._() {
    _init();
  }

  void _init() async {
    BnLog.info(text: 'Wamp Init', methodName: '_init', className: toString());
    runner();
  }

  void refresh() {
    if (!kIsWeb) {
      BnLog.info(
          text: 'Wamp refresh after offline',
          methodName: 'refresh',
          className: toString());
    }
    if (_isWebsocketRunning == false) {
      _initWamp();
    }
  }

  ///called from App and put to queue
  Future addToWamp<T>(BnWampMessage message) {
    _put(message);
    return message.completer.future;
  }

  void _put(BnWampMessage message) {
    calls[message.requestId] = message;
    streamController.sink.add(message);
  }

  Future<void> _sendToWampFromRunner(BnWampMessage message) async {
    //check timed out
    if ((DateTime.now().difference(message.dateTime)) >
            const Duration(seconds: 10) &&
        message.completer.isCompleted == false) {
      message.completer.completeError(
          TimeoutException('WampV2_runner not started within 10 secs'));
      calls.remove(message.requestId);
    }

    channel?.sink.add(message.getMessageAsJson);
  }

  Future<WampConnectionState> _initWamp() async {
    if (_isConnecting == true) {
      await Future.delayed(const Duration(milliseconds: 5000));
      if (!kIsWeb) {
        BnLog.trace(
            text: 'is connecting',
            methodName: '_initWamp',
            className: toString());
      }
      return WampConnectionState.failed;
    }
    if (!kIsWeb) {
      var connectedState = await InternetConnectionChecker().connectionStatus;
      if (connectedState == InternetConnectionStatus.disconnected) {
        return WampConnectionState.offline;
      }
    }
    _isConnecting = true;
    _retryLimit = 3;
    var startResult = await _startStream();
    _isConnecting = false;
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

  Future<void> _shakeHands() async {
    if (_startShakeHands == true) {
      return;
    }
    if (_hadShakeHands == false) {
      _startShakeHands = true;
      if (!kIsWeb) {
        BnLog.debug(
            text: 'shakeHands',
            methodName: 'shakeHands',
            className: toString());
      }
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

  void runner() async {
    streamController.stream.listen((message) async {
      runZonedGuarded(() async {
        queue.add(message);
        while (_isWebsocketRunning == false) {
          var res = await _initWamp()
              .timeout(const Duration(seconds: 10))
              .catchError((error) {
            return WampConnectionState.failed;
          });
          if (!kIsWeb) {
            BnLog.trace(
                text: 'wampRes init ${res.toString()}',
                methodName: 'runner',
                className: toString());
          }
          if (res == WampConnectionState.failed) {
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          } else if (res == WampConnectionState.connecting) {
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          } else if (res == WampConnectionState.offline) {
            await Future.delayed(const Duration(milliseconds: 5000));
            continue;
          }
        }
        if (DateTime.now().difference(_busyTimeStamp) >
            const Duration(seconds: 5)) {
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
                message.completer.completeError(TimeoutException(
                    'WampV2_runner not started within 10 secs'));
              }
              calls.remove(message.requestId);
              busy = true;
              continue;
            }
            await _sendToWampFromRunner(nextMessage)
                .timeout(const Duration(seconds: 5));
            if (!kIsWeb) {
              BnLog.debug(
                  className: toString(),
                  methodName: 'send message finished ',
                  text:
                      'id: ${message.requestId} target ${message.endpoint} - Message:$message');
            }

            //queue.removeFirst();
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
      if (_isWebsocketRunning) return true; //check if its already running

      if ((localTesting || useSelfCreatedCertificate) && !kIsWeb) {
        HttpOverrides.global = MyHttpOverrides();
      }
      final url = _getLink();
      channel = WebSocketChannel.connect(
        Uri.parse(url), //connect to a websocket
      );
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
            welcomeCompleter.complete();
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
            // [RESULT, CALL.Request|id, Details|dict, YIELD.Arguments|list, YIELD.ArgumentsKw|dict]
            if (!kIsWeb) BnLog.debug(text: 'channel result $wampMessage');
            //print('channel runner $wampMessage');

            var messageResult = wampMessage[2];
            resultStreamController.add(messageResult.runtimeType);
            try {
              var rt = RealtimeUpdateMapper.fromMap(messageResult);
              _realTimeUpdateStreamController.sink.add(rt);
            } catch (e) {}

            calls[requestId]?.completer.complete(messageResult);
            calls.remove(requestId);

            return;
          } else if (wampMessageType == WampMessageType.error) {
            //   [ERROR, CALL, CALL.Request|id, Details|dict, Error|uri]
            calls[wampMessage[2]]
                ?.completer
                .completeError(WampError(wampMessage[3]));
            calls.remove(wampMessage[2]);
          } else if (wampMessageType == WampMessageType.subscribe) {
            // [SUBSCRIBE, Request|id, Options|dict, Topic|uri]
            BnLog.debug(text: 'subscribe $wampMessage');
            return;
          } else if (wampMessageType == WampMessageType.subscribed) {
            // [SUBSCRIBED, SUBSCRIBE.Request|id, Subscription|id]
            //    [33, 713845233, 5512315355]
            var messageResult = wampMessage[2];
            subscriptions.add(messageResult);
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
              var result = RealtimeUpdateMapper.fromMap(messageResult);
              eventStreamController.add(result);
              BnLog.trace(text: result.toString());
            } catch (e) {
              BnLog.error(text: e.toString(), className: toString());
            }
            BnLog.debug(text: 'event $wampMessage');
            return;
          } else {
            var typeId = wampMessage[0];

            BnLog.error(
                text: 'WAMP unknown messageType typeId: $typeId $wampMessage');
          }
        },
        onDone: () {
          _resetWampState();
        },
        onError: (err) async {
          if (_isWebsocketRunning == false && _lastConnectionStatus == true) {
            _connectedStreamController.sink.add(false);
            _lastConnectionStatus == false;
          }
          _isWebsocketRunning = false;
          _hadShakeHands = false;
          if (_retryLimit > 0) {
            await Future.delayed(const Duration(milliseconds: 500));
            _retryLimit--;
            if (!kIsWeb) {
              BnLog.trace(
                  text: 'WampStream error ${err.toString()} restart Stream',
                  methodName: 'startStream',
                  className: toString());
            }
            _startStream();
          } else {
            if (!kIsWeb) {
              BnLog.trace(
                  text: 'WampStream error ${err.toString()} too much fails',
                  methodName: 'startStream',
                  className: toString());
            }
            if (!welcomeCompleter.isCompleted) {
              welcomeCompleter.completeError(e);
            }
            _isConnecting = false;
            return false;
          }
        },
      );
      await welcomeCompleter.future;
      _connectionErrorLogged = false;
      _isWebsocketRunning = true;
      if (_lastConnectionStatus == false) {
        _connectedStreamController.sink.add(true);
        _lastConnectionStatus = true;
      }
      _isConnecting = false;
      return true;
    }, (error, stack) {
      if (!_connectionErrorLogged) {
        BnLog.error(text: 'Wamp Error Close Wamp', exception: error);
        _connectionErrorLogged = true;
      }
      _resetWampState();
    })?.catchError((error) {
      if (!kIsWeb) BnLog.error(text: 'error wamp ->$error');
      _isConnecting = false;
      return false;
    });
    return true;
  }

  void _closeStream() {
    //disposes of the stream
    if (channel != null) {
      channel!.sink.close();
    }
    _resetWampState();
  }

  void closeAndReconnect() {
    _closeStream();
    _initWamp();
  }

  void _resetWampState() {
    if (_isWebsocketRunning == false) {
      _connectedStreamController.sink.add(false);
    }
    _isWebsocketRunning = false;
    _hadShakeHands = false;
    _startShakeHands = false;
    subscriptions.clear();
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
    if (!kIsWeb) {
      BnLog.debug(
          className: 'Wamp_V2',
          text: 'Will open new Session $actualServerHost',
          methodName: 'getSession');
    }
    actualHttpSServerHost = actualServerHost;
    return link;
  }
}
