import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickalert/quickalert.dart';

import '../../generated/l10n.dart';
import '../../helpers/device_info_helper.dart';
import '../../helpers/keyboard_helper.dart';
import '../../helpers/notification/toast_notification.dart';
import '../../helpers/time_converter_helper.dart';
import '../../models/friend.dart';
import '../../pages/widgets/data_widget_left_right_small_text.dart';
import '../../pages/widgets/no_connection_warning.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../../providers/friends_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../widgets/bottom_sheets/base_bottom_sheet_widget.dart';
import '../widgets/common_widgets/multi_expandable_button_widget.dart';
import '../widgets/common_widgets/tinted_cupertino_button.dart';
import '../widgets/expandable_floating_action_button.dart';
import 'widgets/edit_friend_dialog.dart';
import 'widgets/friends_action_sheet.dart';
import 'widgets/nearby_widget.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendsPage();
}

class _FriendsPage extends ConsumerState with WidgetsBindingObserver {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchTextController.text = ref.read(friendNameProvider);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(friendsLogicProvider).refreshFriends();
    }
  }

  _runRefreshTimer() {
    final _ = Timer(
      const Duration(seconds: 3),
      () {
        ref.read(friendsLogicProvider).refreshFriends();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var networkAvailable = ref.watch(networkAwareProvider);
    var actionButton = MultiExpandableButton(
      onPressed: () {},
      tooltip: '',
      iconData: AnimatedIcons.menu_close,
      children: [
        MultiButton(
            heroTag: 'addFABTag',
            labelText: Localize.of(context).addnewfriend,
            onPressed: () async {
              var _ = await EditFriendDialog.show(
                context,
                friendDialogAction: FriendsAction.addNew,
              );
            },
            icon: const Icon(Icons.add)),
        MultiButton(
            heroTag: 'addWithCodeFABTag',
            labelText: Localize.of(context).addfriendwithcode,
            onPressed: () async {
              var _ = await EditFriendDialog.show(
                context,
                friendDialogAction: FriendsAction.addWithCode,
              );
            },
            icon: const Icon(Icons.pin)),
        MultiButton(
            heroTag: 'refreshFABTag',
            labelText: Localize.of(context).refresh,
            icon: const Icon(Icons.update),
            onPressed: () async {
              ref.read(friendsLogicProvider).refreshFriends();
            }),
      ],
    );
    /*ExpandableFloatingActionButton(
        distance: 90,
        startAngleInDegrees: 00,
        buttonIcon: const Icon(Icons.menu_open_rounded),
        children: [
          FloatingActionButton(
              heroTag: 'addFABTag',
              onPressed: () async {
                var _ = await EditFriendDialog.show(
                  context,
                  friendDialogAction: FriendsAction.addNew,
                );
              },
              child: const Icon(Icons.add)),
          FloatingActionButton(
              heroTag: 'addWithCodeFABTag',
              onPressed: () async {
                var _ = await EditFriendDialog.show(
                  context,
                  friendDialogAction: FriendsAction.addWithCode,
                );
              },
              child: const Icon(Icons.pin)),
          FloatingActionButton(
              heroTag: 'refreshFABTag',
              child: const Icon(Icons.update),
              onPressed: () async {
                ref.read(friendsLogicProvider).refreshFriends();
              }),
        ]);*/
    return Scaffold(
      floatingActionButton: actionButton,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            leading: const Icon(CupertinoIcons.group),
            largeTitle: Text(Localize.of(context).friends),
            //middle: Text(Localize.of(context).friends),
            trailing: (networkAvailable.connectivityStatus ==
                    ConnectivityStatus.wampConnected)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () async {
                          if (mounted) {
                            dismissKeyboard(context);
                          }
                          if (GetPlatform.isAndroid &&
                              !await DeviceHelper
                                  .isAndroidGreaterOrEqualVersion(7)) {
                            showToast(message: 'No support Android < 7');
                            return;
                          }
                          if (!context.mounted) {
                            return;
                          }
                          var action = await showCupertinoModalBottomSheet(
                              backgroundColor: CupertinoDynamicColor.resolve(
                                  CupertinoColors.systemBackground, context),
                              context: context,
                              builder: (context) {
                                return const FriendsActionModal();
                              });

                          //FriendsActionModal.show(context);
                          if (action == null || !mounted) return;
                          if (action == FriendsAction.addNearby &&
                              context.mounted) {
                            await context.pushNamed(
                                AppRoute.linkFriendDevicePage.name,
                                queryParameters: {
                                  'deviceType': DeviceType.advertiser,
                                  'friendsAction': FriendsAction.addNearby,
                                });
                            _runRefreshTimer();
                            return;
                          }
                          if (action == FriendsAction.acceptNearby &&
                              context.mounted) {
                            await context.pushNamed(
                                AppRoute.linkFriendDevicePage.name,
                                queryParameters: {
                                  'deviceType': DeviceType.browser,
                                  'friendsAction': FriendsAction.acceptNearby
                                });

                            _runRefreshTimer();
                            return;
                          }
                          if (!context.mounted) return;
                          var _ = await EditFriendDialog.show(
                            context,
                            friendDialogAction: action,
                          );
                          // if (result != null) {}
                        },
                        child: const Icon(Icons.menu),
                      ),
                    ],
                  )
                : const Icon(Icons.offline_bolt_outlined),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              if (mounted) {
                dismissKeyboard(context);
              }
              return ref.read(friendsLogicProvider).refreshFriends();
            },
          ),
          if (ref.watch(networkAwareProvider).connectivityStatus !=
              ConnectivityStatus.wampConnected)
            const SliverToBoxAdapter(
              child: FractionallySizedBox(
                  widthFactor: 0.9, child: ConnectionWarning()),
            ),
          SliverToBoxAdapter(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CupertinoSearchTextField(
                    controller: _searchTextController,
                    onChanged: (value) {
                      ref.read(friendNameProvider.notifier).state = value;
                    },
                    onSubmitted: (value) {
                      ref.read(friendNameProvider.notifier).state = value;
                    },
                    onSuffixTap: () {
                      ref.read(friendNameProvider.notifier).state = '';
                      _searchTextController.text = '';
                    },
                  ),
                ),
              ),
            ),
          ),
          Builder(builder: (context) {
            var friends = ref.watch(filteredFriends);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index % 2 == 0) {
                    var friend = friends[(index / 2).round()];
                    return Dismissible(
                      key: ObjectKey(friend.hashCode),
                      child: _friendRow(context, friend),
                      confirmDismiss: (DismissDirection direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await QuickAlert.show(
                              context: context,
                              showCancelBtn: true,
                              type: QuickAlertType.warning,
                              title: Localize.of(context).deletefriend,
                              text:
                                  '${Localize.of(context).delete}: ${friend.name}',
                              confirmBtnText: Localize.current.delete,
                              confirmBtnColor: Colors.redAccent,
                              cancelBtnText: Localize.current.cancel,
                              onConfirmBtnTap: () {
                                ref
                                    .read(friendsLogicProvider)
                                    .deleteRelationShip(friend.friendId);
                                context.pop();
                              });
                        } else {
                          var result = await EditFriendDialog.show(context,
                              friendDialogAction: FriendsAction.edit,
                              friend: friend);
                          if (result == null || !context.mounted) return false;
                          ref.read(friendsLogicProvider).updateFriend(
                              friend.copyWith(
                                  name: result.name,
                                  color: result.color,
                                  isActive: result.active));
                        }
                        setState(() {});
                        return false; //always return true when list not changed
                      },
                      background: Container(
                          color: Colors.greenAccent,
                          child: CupertinoListTile(
                              title: Text(Localize.of(context).editfriend),
                              leading: const Icon(Icons.edit,
                                  color: Colors.white, size: 36.0))),
                      secondaryBackground: Container(
                        color: Colors.redAccent,
                        child: CupertinoListTile(
                          title: Text(Localize.of(context).deletefriend),
                          trailing: const Icon(Icons.delete,
                              color: Colors.white, size: 36.0),
                        ),
                      ),
                    );
                  } else {
                    return Divider(
                      color: CupertinoTheme.of(context).primaryColor,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    );
                  }
                },
                childCount: (friends.length * 2) - 1,
              ),
            );
          }),
        ],
      ),
    );
  }

  _friendRow(BuildContext context, Friend friend) {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 5),
      child: Row(
        children: [
          Container(
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemBackground, context),
            width: 40,
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Column(children: [
                Visibility(
                  visible: friend.isOnline,
                  child: const Icon(
                    CupertinoIcons.link_circle_fill,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: friend.color,
                  child: Text(friend.name.substring(0, 1)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: friend.isActive,
                  child: Icon(
                    CupertinoIcons.eye_fill,
                    color: friend.color,
                    size: 20,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.name,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)),
                Divider(
                  indent: 0,
                  endIndent: 20,
                  color: CupertinoTheme.of(context).primaryColor,
                  height: 1,
                ),
                //Status and online
                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionRight: friend.getFriendStatusText(context),
                      descriptionLeft: Localize.of(context).status,
                      rightWidget: Container()),
                if (friend.requestId > 0 && !friend.codeExpired)
                  Text(
                    Localize.of(context)
                        .tellcode(friend.name, friend.requestId),
                    style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(14),
                        fontWeight: FontWeight.bold,
                        color: CupertinoTheme.of(context).primaryColor),
                  ),
                if (friend.requestId > 0 && friend.codeExpired)
                  Text(
                    Localize.of(context).codeExpired,
                    style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(14),
                        color: CupertinoTheme.of(context).primaryColor),
                  ),

                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionRight:
                          friend.timestamp == null || friend.timestamp == 0
                              ? Localize.of(context).never
                              : Localize.of(context).dateTimeSecIntl(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      friend.timestamp!),
                                  DateTime.fromMillisecondsSinceEpoch(
                                      friend.timestamp!)),
                      descriptionLeft: Localize.of(context).lastseen,
                      rightWidget: Container()),
                if (friend.requestId == 0)
                  Divider(
                    height: 1,
                    color: CupertinoTheme.of(context).primaryColor,
                    endIndent: 20,
                  ),
                //Speed
                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionLeft: Localize.of(context).speed,
                      descriptionRight:
                          '${friend.realSpeed.toStringAsFixed(1)} km/h',
                      rightWidget: Container()),
                //driven meters
                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionRight: friend.formatDistance(),
                      descriptionLeft: Localize.of(context).metersOnRoute,
                      rightWidget: Container()),
                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionRight:
                          '${friend.timeToUser != null ? TimeConverter.millisecondsToDateTimeString(value: friend.timeToUser ?? 0) : '0 s'} ${(friend.timeToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}',
                      descriptionLeft: Localize.of(context).timeToMe,
                      rightWidget: Container()),
                if (friend.requestId == 0)
                  DataWidgetLeftRightSmallTextContent(
                      descriptionRight: '${friend.distanceToUser ?? 0} m ',
                      descriptionLeft: Localize.of(context).distanceToMe,
                      rightWidget: Container()),
              ],
            ),
          ),
          const SizedBox(width: 5),
          CupertinoButton(
            child: const Icon(Icons.edit),
            onPressed: () async {
              var action = await showCupertinoModalBottomSheet(
                  backgroundColor: CupertinoDynamicColor.resolve(
                      CupertinoColors.systemBackground, context),
                  context: context,
                  builder: (context) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: kIsWeb
                            ? MediaQuery.of(context).size.height * 0.4
                            : MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: BaseBottomSheetWidget(children: [
                        CupertinoFormSection(
                            header: Text(Localize.of(context)
                                .editFriendHeader(friend.name)),
                            children: [
                              SizedTintedCupertinoButton(
                                child: Row(children: [
                                  const Icon(Icons.edit),
                                  Expanded(
                                    child:
                                        Text(Localize.of(context).editfriend),
                                  ),
                                ]),
                                onPressed: () {
                                  context.pop(FriendsAction.edit);
                                },
                              ),
                              CupertinoFormSection(
                                  header: Text(Localize.of(context)
                                      .deleteFriendHeader(friend.name)),
                                  children: [
                                    SizedTintedCupertinoButton(
                                      child: Row(children: [
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        Expanded(
                                          child: Text(Localize.of(context)
                                              .deletefriend),
                                        ),
                                      ]),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, FriendsAction.delete);
                                      },
                                    ),
                                  ]),
                            ]),
                      ]),
                    );
                  });
              if (action == FriendsAction.edit) {
                if (!context.mounted) return;
                var result = await EditFriendDialog.show(context,
                    friend: friend, friendDialogAction: FriendsAction.edit);
                if (result != null) {
                  if (!context.mounted) return;
                  ref.read(friendsLogicProvider).updateFriend(friend.copyWith(
                      name: result.name,
                      color: result.color,
                      isActive: result.active));
                }
              } else if (action == FriendsAction.delete) {
                ref
                    .read(friendsLogicProvider)
                    .deleteRelationShip(friend.friendId);
              }
              if (context.mounted) {
                dismissKeyboard(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
