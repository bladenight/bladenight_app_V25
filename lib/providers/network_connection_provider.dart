import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import '../helpers/debug_helper.dart';
import '../helpers/logger/logger.dart';
import '../wamp/wamp_v2.dart';

/// States to connection to internet and wamp server
enum ConnectivityStatus {
  /// unknown state (default)
  unknown,

  /// device has no connection to internet
  internetOffline,

  /// device is connected to internet but Wamp server is disconnected
  wampNotConnected,

  /// Wamp server is reachable and connected
  wampConnected,
}

class NetworkStateModel {
  const NetworkStateModel({required this.connectivityStatus});

  @override
  String toString() {
    return 'NetworkStateModel State:$connectivityStatus';
  }

  final ConnectivityStatus connectivityStatus;
}

class NetworkDetectorNotifier extends StateNotifier<NetworkStateModel> {
  late final AppLifecycleListener? _appLifecycleListener;
  static bool _isInBackground = false;
  static bool _wasWampDisconnected = false;

  static const _initialNetworkState =
      NetworkStateModel(connectivityStatus: ConnectivityStatus.unknown);

  ConnectivityStatus connectivityStatus = ConnectivityStatus.wampNotConnected;

  StreamSubscription? _icCheckerSubscription;
  StreamSubscription? _isServerConnectedSubscription;

  NetworkDetectorNotifier() : super(_initialNetworkState) {
    if (kIsWeb) {
      setStateIfChanged(ConnectivityStatus.wampConnected);
      return;
    }
    init();
  }

  final bool printDebug = true && kDebugMode;

  refresh() {
    _checkStatus(null);
  }

  init() {
    //see memory leak issue
    // https://github.com/OutdatedGuy/internet_connection_checker_plus?tab=readme-ov-file
    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        _icCheckerSubscription?.resume;
        _isServerConnectedSubscription?.resume;
        _checkStatus(null);
        _isInBackground = false;
        BnLog.verbose(text: 'network_connection_provider is not in background');
      },
      onHide: () {
        _icCheckerSubscription?.pause;
        _isServerConnectedSubscription?.pause;
        _isInBackground = true;
        BnLog.verbose(text: 'set network_connection_provider to background');
      },
      onPause: () {
        _icCheckerSubscription?.pause;
        _isServerConnectedSubscription?.pause;
        _isInBackground = true;
        BnLog.verbose(text: 'set network_connection_provider to background');
      },
    );

    _isServerConnectedSubscription =
        WampV2().wampConnectedStreamController.stream.listen((status) {
      //check same state
      if (status == WampConnectedState.connected &&
          state.connectivityStatus == ConnectivityStatus.wampConnected) {
        return;
      }

      if (status == WampConnectedState.disconnected &&
          state.connectivityStatus == ConnectivityStatus.wampNotConnected) {
        return;
      }
      // check and set state
      if (status == WampConnectedState.connected &&
          state.connectivityStatus != ConnectivityStatus.wampConnected) {
        _checkStatus(ConnectivityStatus.wampConnected);
      } else if (status == WampConnectedState.disconnected &&
          state.connectivityStatus != ConnectivityStatus.wampNotConnected) {
        _checkStatus(ConnectivityStatus.wampNotConnected);
      }
    });
  }

  @override
  void dispose() {
    _icCheckerSubscription?.cancel();
    _isServerConnectedSubscription?.cancel();
    _appLifecycleListener?.dispose();
    _isServerConnectedSubscription = null;
    _icCheckerSubscription = null;
    _appLifecycleListener = null;
    super.dispose();
  }

  void _checkStatus(ConnectivityStatus? result) async {
    if (_isInBackground) return;
    if (result != null && result == ConnectivityStatus.wampConnected) {
      setStateIfChanged(ConnectivityStatus.wampConnected);
      return;
    }
    bool isOnline = false;
    try {
      isOnline = true;
    } on SocketException catch (e) {
      BnLog.error(
          text:
              'Error on NetworkConnection ${e.message},${e.address},${e.osError}',
          methodName: '_checkStatus',
          className: toString());
      isOnline = false;
    }
    if (isOnline == true) {
      if (_wasWampDisconnected == true && !WampV2().webSocketIsConnected) {
        await Future.delayed(Duration(seconds: 1));
        var wampInitResult = await WampV2().refresh();
        debugPrintTime('nw_conn wampInitResult is  $wampInitResult');
      }
      if (WampV2().webSocketIsConnected) {
        _wasWampDisconnected = false;
        setStateIfChanged(ConnectivityStatus.wampConnected);
      } else {
        _wasWampDisconnected = true;
        setStateIfChanged(ConnectivityStatus.wampNotConnected);
      }
    } else {
      setStateIfChanged(ConnectivityStatus.internetOffline);
      _wasWampDisconnected = true;
    }
  }

  void setStateIfChanged(ConnectivityStatus connectivityStatus) {
    if (state.connectivityStatus != connectivityStatus) {
      BnLog.verbose(
          text:
              'Network state changed from $state to $connectivityStatus is in bg $_isInBackground',
          methodName: 'setStateIfChanged',
          className: toString());
      state = NetworkStateModel(connectivityStatus: connectivityStatus);
    }
  }

  @override
  String toString() {
    return 'NetworkStateModel '
        'connectivity:${state.connectivityStatus.toString()} ';
  }
}

final networkAwareProvider =
    StateNotifierProvider<NetworkDetectorNotifier, NetworkStateModel>(
        (ref) => NetworkDetectorNotifier());
