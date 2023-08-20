import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app_settings/app_configuration_helper.dart';
import '../app_settings/server_connections.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/wamp/message_types.dart';
import '../models/shake_hand_result.dart';
import '../providers/active_event_notifier_provider.dart';
import 'bn_wamp_message.dart';
import 'http_overrides.dart';
import 'wamp_error.dart';

enum WampConnectionState { unknown, connecting, connected, failed, offline }

class Wamp_V2 {
  static final Wamp_V2 instance = Wamp_V2._();

  var _busyTimeStamp = DateTime.now();

  WebSocketChannel? channel; //initialize a websocket channel
  static bool _isConnecting = false;
  static bool _hadShakeHands = false;
  static bool _startShakeHands = false;
  static int _startShakeHandsRetryCounter = 0;
  bool _isWebsocketRunning = false; //status of a websocket
  bool busy = false;
  final Map<String, BnWampMessage> calls = {};
  int _retryLimit = 3;
  Queue<BnWampMessage> queue = Queue();
  var streamController = StreamController<BnWampMessage>();

  Wamp_V2._() {

    _init();
  }

  void _init() async {
    if (!kIsWeb) {
      FLog.info(
          text: 'Wamp Init',
          methodName: '_init',
          className: toString());
    }
    runner();
  }

  void refresh() {
    if (!kIsWeb) {
      FLog.info(
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
    calls[message.id] = message;
    streamController.sink.add(message);
  }

  Future<void> _sendToWampFromRunner(BnWampMessage value) async {
    //check timed out
    if ((DateTime.now().difference(value.dateTime)) >
            const Duration(seconds: 10) &&
        value.completer.isCompleted == false) {
      value.completer.completeError(
          TimeoutException('WampV2_runner not started within 10 secs'));
      calls.remove(value.id);
    }

    channel?.sink.add(json.encode([
      WampMessageType.call.messageID,
      value.id,
      {}, //no options
      'http://bladenight.app/rpc/${value.endpoint}',
      if (value.message != null) value.message
    ]));
  }

  Future<WampConnectionState> _initWamp() async {
    if (_isConnecting == true) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!kIsWeb) {
        FLog.trace(
            text: 'is connecting',
            methodName: '_initWamp',
            className: toString());
      }
      return WampConnectionState.connecting;
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
        FLog.debug(
            text: 'shakeHands',
            methodName: 'shakeHands',
            className: toString());
      }
      var shkRes = await ShakeHandResult.shakeHandsWamp();
      _startShakeHands = false;

      if (shkRes.rpcException != null) {
        _startShakeHandsRetryCounter++;
        if (!kIsWeb) {
          FLog.warning(
              text: 'shakeHands failed',
              methodName: '_shakeHands',
              className: toString());
        }
        if (_startShakeHandsRetryCounter <= 3) {
          await Future.delayed(const Duration(seconds: 20));
          _shakeHands();
        } else {
          if (!kIsWeb) {
            FLog.warning(
                text:
                    'shakeHands failed after 3 attempts ${shkRes.rpcException}',
                methodName: '_shakeHands',
                className: toString());
          }
        }
        return;
      } else {
        if (!kIsWeb) {
          FLog.info(
              text:
                  'shakeHands = ${shkRes.status}, minBuild:${shkRes.minBuild}',
              methodName: '_shakeHands',
              className: toString());
        }
        _startShakeHandsRetryCounter = 0;
        _hadShakeHands = true;
        shakeHandAppOutdatedResult = shkRes;
        ActiveEventProvider.instance.setAppOutDatedState(!shkRes.status);
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
            FLog.trace(
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
              calls.remove(message.id);
              busy = true;
              continue;
            }
            await _sendToWampFromRunner(nextMessage)
                .timeout(const Duration(seconds: 5));
            if (!kIsWeb) {
              FLog.debug(
                  className: toString(),
                  methodName: 'send message finished ',
                  text:
                      'id: ${message.id} target ${message.endpoint} - Message:$message');
            }

            //queue.removeFirst();
            if (queue.isEmpty) {
              busy = false;
            }
          }
        }
      }, (error, stack) {
        if (!kIsWeb) {
          FLog.error(text: 'Error in WampV2 Stream', exception: error);
        }
      });
    });
  }

  void cleanQueue() {}

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
          var wampMessageType =
              WampMessageTypeHelper.getMessageType(wampMessage[0]);
          if (wampMessageType == WampMessageType.welcome) {
            welcomeCompleter.complete();
            calls.remove(wampMessage[1]);
            //session.calls.remove([message[1]]);
          } else if (wampMessageType == WampMessageType.result) {
            // [RESULT, CALL.Request|id, Details|dict, YIELD.Arguments|list, YIELD.ArgumentsKw|dict]
            if (!kIsWeb) FLog.debug(text: 'channel result $wampMessage');
            //print('channel runner $wampMessage');
            var messageResult = wampMessage[2];
            calls[wampMessage[1]]?.completer.complete(messageResult);
            calls.remove(wampMessage[1]);
          } else if (wampMessageType == WampMessageType.error) {
            //   [ERROR, CALL, CALL.Request|id, Details|dict, Error|uri]
            calls[wampMessage[2]]
                ?.completer
                .completeError(WampError(wampMessage[3]));
            calls.remove(wampMessage[2]);
          } else if (wampMessageType == WampMessageType.subscribe) {
            // [SUBSCRIBE, Request|id, Options|dict, Topic|uri]
            if (!kIsWeb) FLog.debug(text: 'subscribe $wampMessage');
          } else if (wampMessageType == WampMessageType.subscribed) {
            // [SUBSCRIBED, SUBSCRIBE.Request|id, Subscription|id]
            //    [33, 713845233, 5512315355]
            calls.remove(wampMessage[1]);
            if (!kIsWeb) FLog.debug(text: 'subscribed $wampMessage');
          } else if (wampMessageType == WampMessageType.unsubscribe) {
            // [UNSUBSCRIBE, Request|id, SUBSCRIBED.Subscription|id]
            //  [34, 85346237, 5512315355]
            calls.remove(wampMessage[1]);
            if (!kIsWeb) FLog.debug(text: 'unsubscribe $wampMessage');
          } else if (wampMessageType == WampMessageType.unsubscribed) {
            //[UNSUBSCRIBED, UNSUBSCRIBE.Request|id]
            //[35, 85346237]
            calls.remove(wampMessage[1]);
            if (!kIsWeb) FLog.debug(text: 'unsubscribed $wampMessage');
          } else if (wampMessageType == WampMessageType.publish) {
            //    [PUBLISH, Request|id, Options|dict, Topic|uri]
            calls.remove(wampMessage[1]);
            if (!kIsWeb) FLog.debug(text: 'publish $wampMessage');
          } else if (wampMessageType == WampMessageType.event) {
            // [EVENT, SUBSCRIBED.Subscription|id, PUBLISHED.Publication|id, Details|dict]
            //or     [EVENT, SUBSCRIBED.Subscription|id, PUBLISHED.Publication|id, Details|dict,
            // [36, 5512315355, 4429313566, {}]
            //         PUBLISH.Arguments|list, PUBLISH.ArgumentsKw|dict]
            //[36, 5512315355, 4429313566, {}, [], {"color": "orange", "sizes": [23, 42, 7]}]
          } else {
            var typeId = wampMessage[0];
            if (!kIsWeb) {
              FLog.error(
                  text:
                      'WAMP unknown messageType typeId: $typeId $wampMessage');
            }
          }
        },
        onDone: () {
          _isWebsocketRunning = false;
          _hadShakeHands = false;
          _isConnecting = false;
        },
        onError: (err) async {
          _isWebsocketRunning = false;
          _hadShakeHands = false;
          if (_retryLimit > 0) {
            await Future.delayed(const Duration(milliseconds: 500));
            _retryLimit--;
            if (!kIsWeb) {
              FLog.trace(
                  text: 'WampStream error ${err.toString()} restart Stream',
                  methodName: 'startStream',
                  className: toString());
            }
            _startStream();
          } else {
            if (!kIsWeb) {
              FLog.trace(
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
      _isWebsocketRunning = true;
      _isConnecting = false;
      return true;
    }, (error, stack) {
      _isWebsocketRunning = false;
      _hadShakeHands = false;
      _isConnecting = false;
    })?.catchError((error) {
      if (!kIsWeb) FLog.error(text: 'error wamp ->$error');
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
    _isWebsocketRunning = false;
    _hadShakeHands = false;
    _startShakeHands = false;
  }

  void closeAndReconnect() {
    _closeStream();
    _initWamp();
  }

  String _getLink() {
    String link = '';
    if (HiveSettingsDB.useCustomServer) {
      link = HiveSettingsDB.customServerAddress;
    } else if ((kDebugMode && localTesting) && !kIsWeb) {
      link = Platform.isAndroid
          ? defaultTestWampAdressAndroid
          : defaultTestWampAdressOther; //defaultTestWampAdressOther;
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
      FLog.debug(
          className: 'Wamp_V2',
          text: 'Will open new Session $actualServerHost',
          methodName: 'getSession');
    }
    actualHttpSServerHost = actualServerHost;
    return link;
  }
}
