import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
  late final AppLifecycleListener? _listener;
  bool isInBackground = false;

  static const _initialNetworkState =
      NetworkStateModel(connectivityStatus: ConnectivityStatus.unknown);

  StreamController<ConnectivityStatus> get connectionStreamController =>
      _connectionStreamController;

  final StreamController<ConnectivityStatus> _connectionStreamController =
      StreamController<ConnectivityStatus>();

  static bool _wasWampDisconnected = false;

  static InternetConnection get internetConnection => _internetConnection;
  static final InternetConnection _internetConnection =
      InternetConnection.createInstance(
          /*customCheckOptions: [
      InternetCheckOption(uri: WampV2.getServerUri()),
    ],*/
          );

  ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown;
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
    //see https://github.com/OutdatedGuy/internet_connection_checker_plus?tab=readme-ov-file
    _listener = AppLifecycleListener(
      onResume: () {
        _icCheckerSubscription?.resume;
        _checkStatus(null);
        isInBackground = false;
        BnLog.verbose(text: 'network_connection_provider is not in background');
      },
      onHide: () {
        _icCheckerSubscription?.pause;
        isInBackground = true;
        BnLog.verbose(text: 'set network_connection_provider to background');
      },
      onPause: () {
        _icCheckerSubscription?.pause;
        isInBackground = true;
        BnLog.verbose(text: 'set network_connection_provider to background');
      },
    );
    _icCheckerSubscription =
        _internetConnection.onStatusChange.listen((InternetStatus status) {
      BnLog.verbose(
          text:
              '${DateTime.now().toIso8601String()} Internet connection status change: {$status}',
          methodName: 'Internet connection listener',
          className: toString());

      switch (status) {
        case InternetStatus.connected:
          // The internet is now connected
          _checkStatus(ConnectivityStatus.wampNotConnected);
          break;
        case InternetStatus.disconnected:
          // The internet is now disconnected
          _checkStatus(ConnectivityStatus.internetOffline);
          break;
      }
    });

    _isServerConnectedSubscription =
        WampV2().wampConnectedStreamController.stream.listen((status) {
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
    _listener?.dispose();
    _isServerConnectedSubscription = null;
    _icCheckerSubscription = null;
    _listener = null;
    super.dispose();
  }

  void _checkStatus(ConnectivityStatus? result) async {
    if (result != null && result == ConnectivityStatus.wampConnected) {
      setStateIfChanged(ConnectivityStatus.wampConnected);
      _connectionStreamController.sink.add(ConnectivityStatus.wampConnected);
      return;
    }
    bool isOnline = false;
    try {
      if (await _internetConnection.hasInternetAccess) {
        isOnline = true;
      }
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
        _connectionStreamController.sink.add(ConnectivityStatus.wampConnected);
        setStateIfChanged(ConnectivityStatus.wampConnected);
      } else {
        _wasWampDisconnected = true;
        _connectionStreamController.sink
            .add(ConnectivityStatus.wampNotConnected);
        setStateIfChanged(ConnectivityStatus.wampNotConnected);
      }
    } else {
      setStateIfChanged(ConnectivityStatus.internetOffline);
      _wasWampDisconnected = true;
      _connectionStreamController.sink.add(ConnectivityStatus.internetOffline);
    }
  }

  void setStateIfChanged(ConnectivityStatus connectivityStatus) {
    if (state.connectivityStatus != connectivityStatus) {
      BnLog.verbose(
          text: 'Network state changed from $state to $connectivityStatus',
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
