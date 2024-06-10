import 'dart:async';
import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';
import 'package:nearby_service/nearby_service.dart';

import '../../../app_settings/server_connections.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../helpers/notification/toast_notification.dart';
import '../../../helpers/uuid_helper.dart';
import '../../../models/color_mapper.dart';
import '../../../models/friend.dart';
import '../../../providers/friends_provider.dart';
import '../../widgets/data_waiting_indicator.dart';
import '../../widgets/scroll_quick_alert.dart';
import 'friends_action_sheet.dart';

enum DeviceType { advertiser, browser }

/// Simplified application states, main 3:
/// - Preparatory
/// - Device search
/// - Communicating with the connected device
enum AppState { idle, discovering, connected }

const String failedKey = 'failed';
const String messageKey = 'value';
const String senderDeviceIdKey = 'senderDeviceId';
const String deviceIdKey = 'deviceId';

class LinkFriendDevicePage extends StatefulWidget {
  const LinkFriendDevicePage({
    super.key,
    required this.deviceType,
    required this.friendsAction,
  });

  final DeviceType deviceType;
  final FriendsAction friendsAction;

  @override
  State<LinkFriendDevicePage> createState() => _LinkFriendDevicePageState();
}

class _LinkFriendDevicePageState extends State<LinkFriendDevicePage> {
  late final _nearbyService = NearbyService.getInstance(
    /// Define log level here
    logLevel: NearbyServiceLogLevel.debug,
  )..communicationChannelState.addListener(() => setState(() {}));

  StreamSubscription? _peersSubscription;

  AppState _state = AppState.idle;

  final scrollController = ScrollController();
  List<NearbyDevice> devices = [];
  List<NearbyDevice> connectedDevices = [];
  late String deviceName = UUID.createUuid();
  late String communicationState = '';
  final ScrollController _scrollController = ScrollController();

  CommunicationChannelState get _communicationChannelState {
    return _nearbyService.communicationChannelState.value;
  }

  /// List of discovered devices
  List<NearbyDevice> _peers = [];

  /// Temporary solution to check the connection,
  /// use [NearbyService.getConnectedDeviceStream] for this purpose
  /// in your application
  Timer? _connectionCheckTimer;
  Timer? _runStartConnCheckTimer;
  NearbyDevice? _connectedDevice;

  var isInit = false;
  var _canSearchNearby = false;
  var _qrCodeText = '';
  Friend? _tempServerFriend;

  @override
  void initState() {
    _initialize();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      await init();
      if (widget.friendsAction == FriendsAction.addNearby) {
        var dt = DateTime.now();
        var dateString = Localize.current.dateTimeIntl(
          dt,
          dt,
        );
        var friend = await context.read(friendsLogicProvider).addNewFriend(
            '${Localize.of(context).friend} ${Localize.of(context).from} $dateString',
            getRandomColor());
        if (friend == null) {
          if (!mounted) return;
          await ScrollQuickAlert.show(
              context: context,
              showCancelBtn: true,
              showConfirmBtn: false,
              type: QuickAlertType.warning,
              title: Localize.current.addNearBy,
              text: Localize.current.failedAddNearbyTryCode,
              cancelBtnText: Localize.current.cancel);
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          return;
        }
        //get a code from server
        setState(() {
          _tempServerFriend = friend;
          _qrCodeText = '$defaultDeepLinkServerAddress?addFriend&'
              'name=${HiveSettingsDB.myName}&code=${friend.requestId}';
        });
      }
    });
  }

  Future<void> _initialize() async {
    await _nearbyService.initialize();
  }

  @override
  void dispose() {
    _connectionCheckTimer?.cancel();
    _runStartConnCheckTimer?.cancel();
    super.dispose();
    _disposeCommunication();
  }

  void _disposeCommunication() async {
    try {
      BnLog.info(text: '[nearby] _disposeCommunication');
      if (_connectedDevice != null) {
        await _nearbyService.disconnect(_connectedDevice);
        connectedDevices.remove(_connectedDevice);
      }
      if (connectedDevices.isNotEmpty) {
        for (var dev in connectedDevices) {
          await _nearbyService.disconnect(dev);
        }
      }
    } finally {
      await _nearbyService.endCommunicationChannel();
      await _nearbyService.stopDiscovery();
      await _peersSubscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: widget.deviceType == DeviceType.browser
                  ? Text(Localize.of(context).linkNearBy)
                  : Text(Localize.of(context).addNearBy),
              backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
            ),
            SliverToBoxAdapter(
              child: Column(children: [
                if (widget.deviceType == DeviceType.browser &&
                    _canSearchNearby) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 5),
                    child: HtmlWidget(
                      textStyle: TextStyle(
                          fontSize: MediaQuery.textScalerOf(context).scale(14),
                          color: CupertinoTheme.of(context).primaryColor),
                      Localize.of(context).linkAsBrowserDevice(deviceName),
                      customWidgetBuilder: (element) {
                        if (element.className.contains('icon')) {
                          for (var node in element.nodes) {
                            if (node.text != null &&
                                node.text!.contains('plus')) {
                              return const Icon(CupertinoIcons.plus_circle);
                            }
                            if (node.text != null &&
                                node.text!.contains('friendIcon')) {
                              return const Icon(Icons.people);
                            }
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
                if (widget.deviceType == DeviceType.advertiser &&
                    _canSearchNearby &&
                    _tempServerFriend != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 5),
                    child: HtmlWidget(
                      textStyle: TextStyle(
                          fontSize: MediaQuery.textScalerOf(context).scale(14),
                          color: CupertinoTheme.of(context).primaryColor),
                      Localize.of(context).linkOnOtherDevice(
                          deviceName, _tempServerFriend!.requestId),
                      customWidgetBuilder: (element) {
                        if (element.className.contains('icon')) {
                          for (var node in element.nodes) {
                            if (node.text != null &&
                                node.text!.contains('plus')) {
                              return const Icon(CupertinoIcons.plus_circle);
                            }
                            if (node.text != null &&
                                node.text!.contains('friendIcon')) {
                              return const Icon(Icons.people);
                            }
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
                if (!_canSearchNearby)
                  Text(Localize.of(context).noNearbyService),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 5),
                  child: CupertinoFormRow(
                    prefix: Text(Localize.of(context).myName),
                    child: CupertinoTextFormFieldRow(
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        placeholder: Localize.of(context).anonymous,
                        showCursor: true,
                        initialValue: HiveSettingsDB.myName,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return Localize.of(context).missingName;
                          }
                          return null;
                        },
                        autocorrect: false,
                        decoration: BoxDecoration(
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        onChanged: (value) {
                          if (value.isEmpty) return;
                          HiveSettingsDB.setMyName(value);
                        },
                        onSaved: (inputText) {
                          HiveSettingsDB.setMyName(
                              inputText ?? Localize.of(context).anonymous);
                        }),
                  ),
                ),
                if (_tempServerFriend != null &&
                    _canSearchNearby &&
                    widget.deviceType == DeviceType.advertiser)
                  BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    data: _qrCodeText,
                    width: MediaQuery.of(context).size.width * .4,
                  ),
                if (_qrCodeText != '' && devices.isNotEmpty) ...[
                  const SizedBox(
                    height: 2,
                  ),
                  Divider(
                    height: 1,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
                Center(
                  child: Text(
                    communicationState,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(14),
                        color: CupertinoTheme.of(context).primaryColor),
                  ),
                ),
                if (_tempServerFriend == null &&
                    widget.deviceType == DeviceType.advertiser &&
                    (devices.isEmpty || connectedDevices.isEmpty) &&
                    _canSearchNearby) ...[
                  DataWaitingIndicator(text: Localize.of(context).searchNearby),
                  const SizedBox(height: 20)
                ] else if (widget.deviceType == DeviceType.browser &&
                    (devices.isEmpty || connectedDevices.isEmpty) &&
                    _canSearchNearby)
                  DataWaitingIndicator(text: Localize.of(context).searchNearby),
                const SizedBox(height: 20)
              ]),
            ),
            if (_canSearchNearby && _state == AppState.discovering)
              //available
              Builder(builder: (context) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: devices.length, (context, index) {
                    final device = devices[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => _onTabItemListener(device),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(device.info.displayName),
                                    Text(
                                      '',
                                      style: TextStyle(
                                          color: getStateColor(device.status)),
                                    ),
                                  ],
                                ),
                              )),
                              // Request connect
                              //if (widget.deviceType == DeviceType.browser)
                              CupertinoButton(
                                onPressed: () => _connect(device),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  color: getButtonColor(device.status),
                                  child: Center(
                                    child: Text(
                                      getButtonStateName(device.status),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            height: 1,
                            color: CupertinoTheme.of(context).primaryColor,
                          )
                        ],
                      ),
                    );
                  }),
                );
              }),
            if (_canSearchNearby && _state == AppState.connected)
              //connected
              Builder(builder: (context) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: connectedDevices.length, (context, index) {
                    final device = connectedDevices[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => _onTabItemListener(device),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(device.info.displayName),
                                    Text(
                                      communicationState,
                                      style: TextStyle(
                                          color: getStateColor(device.status)),
                                    ),
                                  ],
                                ),
                              )),
                              // Request connect
                              //if (widget.deviceType == DeviceType.browser)
                              CupertinoButton(
                                onPressed: () => _disconnectDevice(device),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  color: getButtonColor(device.status),
                                  child: Center(
                                    child: Text(
                                      Localize.of(context).disconnect,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            height: 1,
                            color: CupertinoTheme.of(context).primaryColor,
                          )
                        ],
                      ),
                    );
                  }),
                );
              }),
          ]),
    );
  }

  String getStateName(NearbyDeviceStatus state) {
    switch (state) {
      case NearbyDeviceStatus.available:
        return Localize.of(context).connecting;
      case NearbyDeviceStatus.connecting:
        return Localize.of(context).connecting;
      case NearbyDeviceStatus.connected:
        return Localize.of(context).connected;
      case NearbyDeviceStatus.failed:
        return Localize.of(context).failed;
      default:
        return Localize.of(context).unknown;
    }
  }

  String getButtonStateName(NearbyDeviceStatus state) {
    switch (state) {
      case NearbyDeviceStatus.available:
        return Localize.current.connecting;
      case NearbyDeviceStatus.connecting:
        return Localize.current.connecting;
      case NearbyDeviceStatus.failed:
        return Localize.current.failed;
      default:
        return Localize.current.disconnect;
    }
  }

  Color getStateColor(NearbyDeviceStatus state) {
    switch (state) {
      case NearbyDeviceStatus.unavailable:
        return Colors.black;
      case NearbyDeviceStatus.failed:
        return Colors.red;
      case NearbyDeviceStatus.available:
        return Colors.lightBlue;
      case NearbyDeviceStatus.connected:
        return Colors.green;
      case NearbyDeviceStatus.connecting:
        return Colors.yellowAccent;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(NearbyDeviceStatus state) {
    switch (state) {
      case NearbyDeviceStatus.available:
        return Colors.lightGreen;
      case NearbyDeviceStatus.connecting:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  _onTabItemListener(NearbyDevice device) async {
    Map<String, dynamic> jsonMap = {'test': '123'};
    Map<String, dynamic> testMap = {
      'value': json.encode(jsonMap),
      'id': UUID.createShortUuid()
    };
    _send(NearbyMessageTextRequest.fromJson(testMap));
    if (device.status != NearbyDeviceStatus.connected) return;
  }

  Future<void> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName =
            '${HiveSettingsDB.myName}_${androidInfo.model}_${HiveSettingsDB.sessionShortUUID}';
      });
      // location permission
      await Permission.location.isGranted; // Check Permission
      await Permission.location.request(); // Ask
      _canSearchNearby = true;
    }
    if (Platform.isIOS) {
      setState(() {
        deviceName =
            '${HiveSettingsDB.myName}_iOS_${HiveSettingsDB.sessionShortUUID}';
      });
      _canSearchNearby = true;
    }

    _startProcess();
  }

  Future<void> _startProcess() async {
    final platformsReady = await _checkPlatforms();
    if (platformsReady) {
      await _discover();
    }
  }

  Future<bool> _checkPlatforms() async {
    if (Platform.isAndroid) {
      final isGranted = await _nearbyService.android?.requestPermissions();
      final wifiEnabled = await _nearbyService.android?.checkWifiService();
      return (isGranted ?? false) && (wifiEnabled ?? false);
    } else if (Platform.isIOS) {
      _nearbyService.ios
          ?.setIsBrowser(value: widget.deviceType == DeviceType.browser);

      return true;
    } else {
      return false;
    }
  }

  Future<void> _discover() async {
    if (!mounted) return;
    final result = await _nearbyService.discover();
    if (result) {
      setState(() {
        _state = AppState.discovering;
        communicationState = 'Suche Geräte';
      });
      _peersSubscription = _nearbyService.getPeersStream().listen((peers) {
        if (_peers.toString() == peers.toString()) {
          return;
        }
        _peers = peers;
        setState(() {
          devices.clear();
          connectedDevices.clear();
          if (peers.isEmpty) {
            _state = AppState.discovering;
            return;
          }
          devices.addAll(peers);
          connectedDevices.addAll(peers
              .where((d) => d.status == NearbyDeviceStatus.connected)
              .toList());
        });
        setState(() async {
          await Future.delayed(const Duration(milliseconds: 200));
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
        });
      });
    }
  }

  Future<void> _connect(NearbyDevice device) async {
    // Be careful with already connected devices,
    // double connection may be unnecessary
    final result = await _nearbyService.connect(device);
    BnLog.info(text: '[nearby] _connect ${device.info.displayName} request ');
    BnLog.info(
        text:
            '[nearby] _connect connected ${device.status.isConnected} request ');
    if (result || device.status.isConnected) {
      final channelStarting = _tryCommunicate(device);
      if (!channelStarting) {
        _connectionCheckTimer = Timer.periodic(
          const Duration(seconds: 1),
          (_) => _tryCommunicate(device),
        );
      }
    }
    // browser has been connected to advertiser
    // advertiser is sending data to browser
  }

  bool _tryCommunicate(NearbyDevice device) {
    NearbyDevice? selectedDevice;

    try {
      selectedDevice = _peers.firstWhere(
        (element) => element.info.id == device.info.id,
      );
    } catch (_) {
      return false;
    }

    if (!selectedDevice.status.isConnected) {
      try {
        _startCommunicationChannel(device);
      } finally {
        _connectionCheckTimer?.cancel();
        _connectionCheckTimer = null;
      }
      return true;
    }
    return false;
  }

  void _startCommunicationChannel(NearbyDevice device) {
    if (!_communicationChannelState.isNotConnected) return;
    communicationState = 'Starte Nahfeld-Kommunikation';
    _nearbyService.startCommunicationChannel(
      NearbyCommunicationChannelData(
        device.info.id,
        messagesListener: NearbyServiceMessagesListener(
          onData: _messagesListener,
          onCreated: () {
            BnLog.info(
                text: '[nearby] onCreated ${device.info.displayName} request ');
            setState(() {
              _connectedDevice = device;
              var dev = devices.where((d) => d.info.id == device.info.id);
              if (dev.isNotEmpty) {
                connectedDevices.add(dev.elementAt(0));
                devices.remove(dev.elementAt(0));
              }
              _state = AppState.connected;
              if (widget.deviceType == DeviceType.advertiser) {
                communicationState = 'Nahfeld-Kommunikation OK';
              }
              if (widget.deviceType == DeviceType.browser) {
                communicationState = 'Warte auf Koppeln Freund';
              }
            });
            Map<String, dynamic> jsonMap = {
              'channelCreated': 'true',
              'deviceName': device.info.displayName
            };
            Map<String, dynamic> channelCreatedMap = {
              'value': json.encode(jsonMap),
              'id': UUID.createShortUuid()
            };
            if (widget.deviceType == DeviceType.advertiser) {
              var trys = 0;
              _runStartConnCheckTimer =
                  Timer.periodic(const Duration(seconds: 1), (_) async {
                _send(NearbyMessageTextRequest.fromJson(channelCreatedMap));
                trys++;
                if (trys > 5) {
                  _runStartConnCheckTimer?.cancel();
                  showToast(
                    message: Localize.current.linkingFailed,
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  if (mounted && Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(true);
                  }
                }
              });
            }
            if (widget.deviceType == DeviceType.browser) {
              _runStartConnCheckTimer =
                  Timer.periodic(const Duration(seconds: 90), (_) {
                showToast(
                  message: Localize.current.linkingFailed,
                );
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(true);
                }
              });
            }
          },
          onError: (e, [StackTrace? s]) {
            BnLog.info(
                text: '[nearby] onerror ${device.info.displayName} request ');
            setState(() {
              connectedDevices = [];
              _connectedDevice = null;
              _state = AppState.idle;
            });
          },
          onDone: () {
            BnLog.info(
                text: '[nearby] onDone ${device.info.displayName} request ');
            setState(() {
              connectedDevices = [];
              _connectedDevice = null;
              _state = AppState.idle;
            });
          },
        ),
      ),
    );
  }

  Future<void> _disconnectDevice(NearbyDevice device) async {
    BnLog.info(text: '[nearby] disconnect ${device.info.displayName} request ');
    if (_connectedDevice != null) {
      await _send(
          NearbyMessageTextRequest.create(value: '{"disconnect":"true"}'));
      await _nearbyService.disconnect(_connectedDevice);
      setState(() {
        communicationState = Localize.of(context).disconnected;
        connectedDevices.remove(_connectedDevice);
        _state = AppState.discovering;
      });
    }
  }

  Future<void> _disconnectedDeviceReceived(NearbyDeviceInfo info) async {
    BnLog.info(text: '[nearby] _disconnectDeviceByInfo $info request ');
    try {
      if (_connectedDevice != null && _connectedDevice!.info.id == info.id) {
        await _nearbyService.disconnect(_connectedDevice);
        setState(() {
          communicationState = 'Freund hat Verbindung getrennt!';
          connectedDevices.remove(_connectedDevice);
          _connectedDevice = null;
          _state = AppState.discovering;
        });
      }
    } finally {
      await _nearbyService.endCommunicationChannel();
      await _nearbyService.stopDiscovery();
      await _peersSubscription?.cancel();
      _startProcess();
    }
  }

  void _messagesListener(
      ReceivedNearbyMessage<NearbyMessageContent> message) async {
    if (_connectedDevice == null) return;
    // Very useful stuff! Process messages according to the type of content
    message.content.byType(
      onTextRequest: (request) {
        BnLog.info(
            text:
                '[nearby] _messagesListener onTextRequest request ${message.content.toString()}');
        _runStartConnCheckTimer?.cancel();
        //_send(NearbyMessageTextResponse(id: request.id));
      },
      onTextResponse: (response) {
        _runStartConnCheckTimer?.cancel();
        BnLog.info(
            text:
                '[nearby] _messagesListener onTextResponse request ${message.content.toString()}');
      },
    );

    try {
      var data = message.content.toJson();
      Map<dynamic, dynamic> dataMap = data;
      if (dataMap.containsKey(messageKey)) {
        var jsonValue = dataMap[messageKey];
        Map<String, dynamic> valueMap = jsonDecode(jsonValue);
        if (valueMap.containsKey('disconnect')) {
          _disconnectedDeviceReceived(message.sender);
          return;
        }
        //Advertiser sent channel OK to Browser
        if (widget.deviceType == DeviceType.browser &&
            valueMap.containsKey('channelCreated') &&
            valueMap.containsKey('deviceName')) {
          var connectedTo = valueMap['deviceName'];
          BnLog.info(
              text: '[nearby] _messagesListener channelCreated $connectedTo} ');

          setState(() {
            communicationState = 'Verbunden mit $connectedTo';
          });
          Map<String, dynamic> jsonMap = {
            'browserToAdvertiserOK': 'true',
          };
          Map<String, dynamic> browserOKMap = {
            'value': json.encode(jsonMap),
            'id': UUID.createShortUuid()
          };
          _send(NearbyMessageTextRequest.fromJson(browserOKMap));
          return;
        }

        if (widget.deviceType == DeviceType.advertiser &&
            valueMap.containsKey('browserToAdvertiserOK') &&
            _connectedDevice != null) {
          setState(() {
            communicationState = 'Sende Daten ...';
          });
          //send friend data to browser -- connection is OK
          _sendFriendDataToBrowser(_connectedDevice!);
          return;
        }

        /// advertiser has sent friendData ( code, name, color )
        ///
        /// browser must send own data as answer
        ///
        ///
        if (widget.deviceType == DeviceType.browser) {
          if (valueMap.containsKey('friendid')) {
            setState(() {
              communicationState = 'Empfange Freund-Daten ...';
            });
            //is friend
            var friend = FriendMapper.fromJson(dataMap[messageKey]);
            var addedFriend = await context
                .read(friendsLogicProvider)
                .addFriendWithCode(
                    friend.name, friend.color, friend.requestId.toString());
            if (addedFriend != null) {
              var answerFriend = Friend(
                  name: HiveSettingsDB.myName, friendId: friend.friendId);
              await _nearbyService.send(
                OutgoingNearbyMessage(
                  content: NearbyMessageTextRequest.create(
                      value: answerFriend.toJson()),
                  receiver: _connectedDevice!.info,
                ),
              );
              await ProviderContainer()
                  .read(friendsLogicProvider)
                  .refreshFriends();
              _nearbyService.disconnect(_connectedDevice);
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              }
            } else {
              Map<String, dynamic> failedMap = {
                failedKey: 'true',
              };
              Map<String, dynamic> failedCreatedMap = {
                'value': json.encode(failedMap),
                'id': UUID.createShortUuid()
              };
              BnLog.warning(
                  text:
                      '[nearby] _messagesListener channelCreated $failedKey} ');
              _send(NearbyMessageTextRequest.fromJson(failedCreatedMap));
            }
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          }
        }
        if (widget.deviceType == DeviceType.advertiser) {
          if (valueMap.containsKey(failedKey)) {
            BnLog.warning(
                text:
                    '[nearby] _messagesListener advertiser failed ${message.content.toString()}} ');
            showToast(
              message: Localize.current.linkingFailed,
            );
          } else {
            setState(() {
              communicationState = 'Freund-Daten Austausch OK.';
            });
            BnLog.info(
                text:
                    '[nearby] _messagesListener advertiser Freund-Daten Austausch ok ${message.content.toString()}} ');
            if (valueMap.containsKey('friendid')) {
              var friend = FriendMapper.fromJson(dataMap[messageKey]);
              bool result = await ProviderContainer()
                  .read(friendsLogicProvider)
                  .updateFriendName(friend.friendId, friend.name);
              if (result) {
                await ProviderContainer()
                    .read(friendsLogicProvider)
                    .refreshFriends();
                showToast(
                  message: Localize.current.linkingSuccessful,
                );
              } else {
                BnLog.warning(
                    text: '[nearby] _messagesListener refresh failed');
              }
            }
          }
          if (mounted && Navigator.of(context).canPop()) {
            _disconnectDevice(_connectedDevice!);
            Navigator.of(context).pop(true);
          }
        }
      }
    } catch (ex) {
      BnLog.error(
          text: 'Could not decode ${message.content.toString()}',
          className: toString());
      showToast(
        message: Localize.current.linkingFailed,
      );
    }
  }

  Future<void> _sendFriendDataToBrowser(NearbyDevice device) async {
    BnLog.info(text: '[nearby] _shareFriendData advertiser ');
    if (_tempServerFriend != null) {
      _tempServerFriend!.name = device.info.displayName;
      _tempServerFriend!.name = HiveSettingsDB.myName;
      _send(NearbyMessageTextRequest.createManually(
          value: _tempServerFriend!.toJson(), id: UUID.createShortUuid()));
    } else {
      await ScrollQuickAlert.show(
          context: context,
          showCancelBtn: true,
          showConfirmBtn: false,
          type: QuickAlertType.warning,
          title: Localize.current.addNearBy,
          text: Localize.current.failedAddNearbyTryCode,
          cancelBtnText: Localize.current.cancel);
      return;
    }
  }

  Future<void> _send(NearbyMessageContent content) async {
    if (_connectedDevice == null) return;
    await _nearbyService.send(
      OutgoingNearbyMessage(
        content: content,
        receiver: _connectedDevice!.info,
      ),
    );
  }
}
