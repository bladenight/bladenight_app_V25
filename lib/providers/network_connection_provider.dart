import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../helpers/logger.dart';
import '../wamp/wamp_v2.dart';

enum ConnectivityStatus { unknown, online, offline, error, serverNotReachable }

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

  late dynamic _connectivity;
  static bool _wasOffline = false;

  ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown;
  StreamSubscription? _icCheckerSubscription;

  final StreamController<InternetConnectionStatus> _currentState =
      StreamController.broadcast();

  Stream<InternetConnectionStatus> get updates => _currentState.stream;

  NetworkDetectorNotifier() : super(_initialNetworkState) {
    if (kIsWeb) {
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.online, serverAvailable: true);
      return;
    }
    _init();
  }

  _init() async {
    _connectivity = InternetConnectionChecker();
    _currentState.addStream(_connectivity.onStatusChange);
    _icCheckerSubscription =
        _connectivity.onStatusChange.listen((InternetConnectionStatus result) {
      _checkStatus(result);
    });
    Timer.periodic(const Duration(seconds: 30), (timer) {
      refresh();
    });
  }

  refresh() {
    _checkStatus(null);
  }

  @override
  void dispose() {
    _icCheckerSubscription?.cancel();
    super.dispose();
  }

  void _checkStatus(InternetConnectionStatus? result) async {
    bool isOnline = false;
    try {
      isOnline = await InternetConnectionChecker()
          .hasConnection; //; await InternetAddress.lookup('skatemunich.de');
    } on SocketException catch (e) {
      if (!kIsWeb) {
        FLog.error(
            text:
                'Error on NetworkConnection ${e.message},${e.address},${e.osError}',
            methodName: '_checkStatus',
            className: toString());
      }
      isOnline = false;
    }
    if (isOnline == true) {
      if (_wasOffline == true) {
        Wamp_V2.instance.refresh();
        _wasOffline = false;
      }
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.online, serverAvailable: true);
    } else {
      state = const NetworkStateModel(
          connectivityStatus: ConnectivityStatus.offline,
          serverAvailable: false);
      _wasOffline = true;
    }
  }

  /// set connection Stat to WampServer
  void setServerConnected(bool value) {
    if (value == state.serverAvailable) {
      return;
    }
    state = NetworkStateModel(
        connectivityStatus: state.connectivityStatus, serverAvailable: value);
  }
}

final networkAwareProvider =
    StateNotifierProvider<NetworkDetectorNotifier, NetworkStateModel>(
        (ref) => NetworkDetectorNotifier());
