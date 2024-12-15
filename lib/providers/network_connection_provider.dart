import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:universal_io/io.dart';

import '../helpers/logger.dart';
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

  final ConnectivityStatus connectivityStatus;
}

class NetworkDetectorNotifier extends StateNotifier<NetworkStateModel> {
  static const _initialNetworkState =
      NetworkStateModel(connectivityStatus: ConnectivityStatus.unknown);

  StreamController<ConnectivityStatus> get connectionStreamController =>
      _connectionStreamController;

  final StreamController<ConnectivityStatus> _connectionStreamController =
      StreamController<ConnectivityStatus>();

  InternetConnection? _internetConnection;

  static bool _wasWampDisconnected = false;

  ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown;
  StreamSubscription? _icCheckerSubscription;
  StreamSubscription? _isServerConnectedSubscription;

  NetworkDetectorNotifier() : super(_initialNetworkState) {
    if (kIsWeb) {
      setStateIfChanged(ConnectivityStatus.wampConnected);
      return;
    }
    _init();
  }

  final bool printDebug = true && kDebugMode;

  _init() async {
    _internetConnection = InternetConnection.createInstance(
        /*customCheckOptions: [
      InternetCheckOption(uri: WampV2.getServerUri()),
    ],*/
        );
    //WampV2().internetConnChecker;
    _icCheckerSubscription =
        _internetConnection!.onStatusChange.listen((InternetStatus status) {
      print(
          '${DateTime.now().toIso8601String()} Internetconnection status change: {$status}');
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
    if (result != null && result == ConnectivityStatus.wampConnected) {
      setStateIfChanged(ConnectivityStatus.wampConnected);
      _connectionStreamController.sink.add(ConnectivityStatus.wampConnected);
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
      if (_wasWampDisconnected == true && !WampV2().webSocketIsConnected) {
        await Future.delayed(Duration(seconds: 1));
        var wampinitres = await WampV2().refresh();
        print('wampinitres ${wampinitres}');
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
      print('Networkstate changed from $state to $connectivityStatus');
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
