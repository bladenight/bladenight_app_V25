import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:universal_io/io.dart';

import '../helpers/logger.dart';
import '../wamp/wamp_v2.dart';

enum ConnectivityStatus {
  unknown,
  online,
  disconnected,
  error,
  serverReachable,
  serverNotReachable
}

class NetworkStateModel {
  const NetworkStateModel(
      {required this.connectivityStatus, required this.serverAvailable});

  final ConnectivityStatus connectivityStatus;
  final bool serverAvailable;
}

class NetworkDetectorNotifier extends StateNotifier<NetworkStateModel> {
  static const _initialNetworkState = NetworkStateModel(
      connectivityStatus: ConnectivityStatus.online, serverAvailable: true);

  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  StreamController<bool> serverConnectionStatusController =
      StreamController<bool>();
  InternetConnection? _internetConnection;

  static bool _wasOffline = false;

  ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown;
  StreamSubscription? _icCheckerSubscription;
  StreamSubscription? _isServerConnectedSubscription;

  NetworkDetectorNotifier() : super(_initialNetworkState) {
    if (kIsWeb) {
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.online, serverAvailable: true);
      return;
    }
    _init();
  }

  _init() async {
    _internetConnection = WampV2().internetConnChecker;
    _icCheckerSubscription =
        _internetConnection!.onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          // The internet is now connected
          _checkStatus(ConnectivityStatus.online);
          break;
        case InternetStatus.disconnected:
          // The internet is now disconnected
          _checkStatus(ConnectivityStatus.disconnected);
          break;
      }
    });

    _isServerConnectedSubscription =
        WampV2().wampConnectedStreamController.stream.listen((event) {
      if (event) {
        _checkStatus(ConnectivityStatus.serverReachable);
      } else {
        _checkStatus(ConnectivityStatus.serverNotReachable);
      }
    });

    /*Timer.periodic(const Duration(seconds: 30), (timer) {
      refresh();
    });*/
  }

  refresh() {
    _checkStatus(null);
  }

  @override
  void dispose() {
    _icCheckerSubscription?.cancel();
    _isServerConnectedSubscription?.cancel();
    _internetConnection = null;
    super.dispose();
  }

  void _checkStatus(ConnectivityStatus? result) async {
    if (result != null && result == ConnectivityStatus.serverReachable) {
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.online, serverAvailable: true);
      return;
    }

    bool isOnline = false;
    try {
      isOnline = await _internetConnection!
          .hasInternetAccess; //; await InternetAddress.lookup('skatemunich.de');
    } on SocketException catch (e) {
      BnLog.error(
          text:
              'Error on NetworkConnection ${e.message},${e.address},${e.osError}',
          methodName: '_checkStatus',
          className: toString());
      isOnline = false;
    }
    if (isOnline == true) {
      if (_wasOffline == true) {
        WampV2().refresh();
        _wasOffline = false;
      }
      state = NetworkStateModel(
          connectivityStatus: ConnectivityStatus.online,
          serverAvailable: WampV2().webSocketIsConnected);
    } else {
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.disconnected,
          serverAvailable: false);
      _wasOffline = true;
    }
  }
}

final networkAwareProvider =
    StateNotifierProvider<NetworkDetectorNotifier, NetworkStateModel>(
        (ref) => NetworkDetectorNotifier());
