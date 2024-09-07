import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:universal_io/io.dart';
import '../../../app_settings/server_connections.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/uuid_helper.dart';
import '../../../models/color_mapper.dart';
import '../../../models/friend.dart';
import '../../../providers/friends_provider.dart';
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

class LinkFriendDevicePage extends ConsumerStatefulWidget {
  const LinkFriendDevicePage({
    super.key,
    required this.deviceType,
    required this.friendsAction,
  });

  final DeviceType deviceType;
  final FriendsAction friendsAction;

  @override
  ConsumerState<LinkFriendDevicePage> createState() =>
      _LinkFriendDevicePageState();
}

class _LinkFriendDevicePageState extends ConsumerState<LinkFriendDevicePage> {
  final scrollController = ScrollController();

  late String deviceName = UUID.createUuid();
  final ScrollController _scrollController = ScrollController();

  var _qrCodeText = '';
  Friend? _tempServerFriend;

  @override
  void initState() {
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
        if (!mounted) return;
        var friend = await ref.read(friendsLogicProvider).addNewFriend(
            '${Localize.of(context).friend} ${Localize.of(context).from} $dateString',
            getRandomColor());
        if (friend == null) {
          if (!mounted) return;
          await QuickAlert.show(
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
                if (widget.deviceType == DeviceType.advertiser) ...[
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
                if (widget.deviceType == DeviceType.browser) ...[
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
                if (_tempServerFriend != null &&
                    widget.deviceType == DeviceType.advertiser)
                  BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    data: _qrCodeText,
                    width: MediaQuery.of(context).size.width * .4,
                  ),
              ]),
            ),
          ]),
    );
  }

  Future<void> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName =
            '${HiveSettingsDB.myName}_${androidInfo.model}_${HiveSettingsDB.sessionShortUUID}';
      });
    }
    if (Platform.isIOS) {
      setState(() {
        deviceName =
            '${HiveSettingsDB.myName}_iOS_${HiveSettingsDB.sessionShortUUID}';
      });
    }
  }
}
