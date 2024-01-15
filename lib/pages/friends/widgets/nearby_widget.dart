import 'dart:async';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';

import '../../../app_settings/app_constants.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../helpers/notification/toast_notification.dart';
import '../../../helpers/uuid_helper.dart';
import '../../../models/friend.dart';
import '../../../providers/friends_provider.dart';
import '../friends_page.dart';

enum DeviceType { advertiser, browser }

const String failedKey = 'failed';
const String messageKey = 'message';
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
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  late String devInfo = UUID.createUuid();

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: widget.deviceType == DeviceType.browser
            ? Text(Localize.of(context).linkNearBy)
            : Text(Localize.of(context).addNearBy),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CupertinoFormSection(
                  header: Text(Localize.of(context).myNameHeader),
                  children: <Widget>[
                    CupertinoTextFormFieldRow(
                        placeholder: Localize.of(context).anonymous,
                        showCursor: true,
                        initialValue: HiveSettingsDB.myName,
                        autocorrect: false,
                        onChanged: (value) {
                          HiveSettingsDB.setMyName(value);
                        },
                        onSaved: (inputText) {
                          HiveSettingsDB.setMyName(
                              inputText ?? Localize.of(context).anonymous);
                        }),
                  ]),
            ),
            if (widget.deviceType == DeviceType.browser)
              Text(Localize.of(context).chooseDeviceToLink),
            if (widget.deviceType == DeviceType.advertiser)
              Text(Localize.of(context).linkOnOtherDevice(devInfo)),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: getItemCount(),
                  itemBuilder: (context, index) {
                    final device = widget.deviceType == DeviceType.advertiser
                        ? connectedDevices[index]
                        : devices[index];
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
                                    Text(device.deviceName),
                                    Text(
                                      getStateName(device.state),
                                      style: TextStyle(
                                          color: getStateColor(device.state)),
                                    ),
                                  ],
                                ),
                              )),
                              // Request connect
                              if (widget.deviceType == DeviceType.browser)
                                CupertinoButton(
                                  onPressed: () => _onButtonClicked(device),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    color: getButtonColor(device.state),
                                    child: Center(
                                      child: Text(
                                        getButtonStateName(device.state),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
            ),
          ],
        ),
      ),
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Localize.of(context).disconnected;
      case SessionState.connecting:
        return Localize.of(context).connecting;
      default:
        return Localize.of(context).connected;
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Localize.current.connecting;
      default:
        return Localize.current.disconnect;
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  _onTabItemListener(Device device) async {
    if (device.state != SessionState.connected) return;
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        devInfo =
            '${androidInfo.model}_${HiveSettingsDB.myName}_${HiveSettingsDB.sessionShortUUID}';
      });
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        devInfo =
            '${iosInfo.localizedModel}_${HiveSettingsDB.myName}_${HiveSettingsDB.sessionShortUUID}';
      });
    }
    await nearbyService.init(
        serviceType: 'mp-connection',
        deviceName: devInfo,
        strategy: Strategy.P2P_POINT_TO_POINT,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) async {
      for (var element in devicesList) {
        BnLog.info(
            text:
                'NearbyService deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}');

        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
        if (element.state == SessionState.connected) {
          switch (widget.friendsAction) {
            case FriendsAction.addNearby:
              var colorLength = ColorConstants.friendPickerColors.length;
              var randomColor = ColorConstants
                  .friendPickerColors[Random().nextInt(colorLength - 1)];
              var friend = await context
                  .read(friendsLogicProvider)
                  .addNewFriend(element.deviceName, randomColor);
              if (friend == null) {
                FlutterPlatformAlert.showAlert(
                    windowTitle: Localize.current.addNearBy,
                    text: Localize.current.failedAddNearbyTryCode);
                return;
              }
              friend.name = HiveSettingsDB.myName;
              nearbyService.sendMessage(element.deviceId, friend.toJson());
              await Future.delayed(const Duration(milliseconds: 200));
              if (mounted) {
                //go back
                Navigator.of(context).pop();
              }
              break;
            default:
              break;
          }
        }
      }

      setState(() {
        devices.clear();
        devices.addAll(devicesList);
        connectedDevices.clear();
        connectedDevices.addAll(devicesList
            .where((d) => d.state == SessionState.connected)
            .toList());
      });
    });

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) async {
      try {
        if (widget.deviceType == DeviceType.browser) {
          Map<dynamic, dynamic> dataMap = data;
          if (dataMap.containsKey(messageKey)) {
            var friend = FriendMapper.fromJson(dataMap[messageKey]);
            var addedFriend = await context
                .read(friendsLogicProvider)
                .addFriendWithCode(
                    friend.name, friend.color, friend.requestId.toString());
            if (addedFriend != null) {
              var answerFriend = Friend(
                  name: HiveSettingsDB.myName, friendId: friend.friendId);
              nearbyService.sendMessage(
                  dataMap[senderDeviceIdKey], answerFriend.toJson());
              await ProviderContainer()
                  .read(friendsLogicProvider)
                  .refreshFriends();
              nearbyService.disconnectPeer(
                  deviceID: dataMap[senderDeviceIdKey]);
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            } else {
              nearbyService.sendMessage(dataMap[senderDeviceIdKey], failedKey);
            }
          }
        }
        if (widget.deviceType == DeviceType.advertiser) {
          Map<dynamic, dynamic> dataMap = data;
          if (dataMap.containsKey(messageKey)) {
            if (dataMap[messageKey] == failedKey) {
              showToast(
                message: Localize.current.linkingFailed,
              );
            } else {
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
              }
            }
          }
        }
      } catch (ex) {
        BnLog.error(text: 'Could not decode $data', className: toString());
        showToast(
          message: Localize.current.linkingFailed,
        );
      }
    });
  }
}
