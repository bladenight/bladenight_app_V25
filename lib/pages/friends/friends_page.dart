import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../helpers/timeconverter_helper.dart';

import '../../models/friend.dart';
import '../../pages/widgets/data_widget_left_right_small_text.dart';
import '../../pages/widgets/no_connection_warning.dart';
import '../../providers/friends_provider.dart';
import 'widgets/edit_friend_dialog.dart';

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
    _searchTextController.text = context.read(friendNameProvider);
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
      context.read(friendsLogicProvider).refreshFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
      return CupertinoPageScaffold(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              leading: const Icon(CupertinoIcons.group),
              largeTitle: Text(Localize.of(context).friends),
              trailing: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () async {
                        context.read(friendsLogicProvider).refreshFriends();
                      },
                      child: const Icon(CupertinoIcons.refresh),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () async {
                        var action = await FriendsActionModal.show(context);
                        if (action != null) {
                          if (!mounted) return;
                          var result = await EditFriendDialog.show(
                            context,
                            friendDialogAction: action,
                          );
                          if (result != null) {}
                        }
                      },
                      child: const Icon(CupertinoIcons.plus_circle),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                return context.read(friendsLogicProvider).refreshFriends();
              },
            ),
            const SliverToBoxAdapter(child: ConnectionWarning()),
            SliverToBoxAdapter(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: ClipRect(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: CupertinoSearchTextField(
                      controller: _searchTextController,
                      onChanged: (value) {
                        context.read(friendNameProvider.notifier).state = value;
                      },
                      onSubmitted: (value) {
                        context.read(friendNameProvider.notifier).state = value;
                      },
                      onSuffixTap: () {
                        context.read(friendNameProvider.notifier).state = '';
                        _searchTextController.text = '';
                      },
                    ),
                  ),
                ),
              ),
            ),
            Builder(builder: (context) {
              var friends = context.watch(filteredFriends);
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
                            var deleteResult =
                                await FlutterPlatformAlert.showCustomAlert(
                                    windowTitle:
                                        Localize.of(context).deletefriend,
                                    text:
                                        '${Localize.of(context).delete}: ${friend.name}',
                                    iconStyle: IconStyle.warning,
                                    positiveButtonTitle:
                                        Localize.current.delete,
                                    negativeButtonTitle:
                                        Localize.current.cancel);
                            if (deleteResult == CustomButton.positiveButton) {
                              if (!mounted) return false;
                              context
                                  .read(friendsLogicProvider)
                                  .deleteRelationShip(friend.friendId);
                            }
                          } else {
                            var result = await EditFriendDialog.show(context,
                                friendDialogAction: FriendsAction.edit,
                                friend: friend);
                            if (result == null || !mounted) return false;
                                context.read(friendsLogicProvider).updateFriend(
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
                                    color: Colors.white, size: 36.0))),
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
                  indent: 20,
                  endIndent: 20,
                  color: CupertinoTheme.of(context).primaryColor,
                  height: 1,
                ),
                //Status and online
                Text(
                    '${Localize.of(context).status}: ${friend.getFriendStatusText(context)}'),
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
                Divider(
                  height: 1,
                  color: CupertinoTheme.of(context).primaryColor,
                  endIndent: 20,
                ),
                //Speed
                DataWidgetLeftRightSmallTextContent(
                    descriptionLeft: Localize.of(context).speed,
                    descriptionRight:
                        '${friend.realSpeed.toStringAsFixed(1)} km/h',
                    rightWidget: Container()),
                //driven meters
                DataWidgetLeftRightSmallTextContent(
                    descriptionRight: friend.formatDistance(),
                    descriptionLeft: Localize.of(context).metersOnRoute,
                    rightWidget: Container()),

                DataWidgetLeftRightSmallTextContent(
                    descriptionRight:
                        '${friend.timeToUser != null ? TimeConverter.millisecondsToDateTimeString(value: friend.timeToUser ?? 0) : '0 s'} ${(friend.timeToUser ?? 0).isNegative ? Localize.of(context).behindMe : Localize.of(context).aheadOfMe}',
                    descriptionLeft: Localize.of(context).timeToMe,
                    rightWidget: Container()),
                DataWidgetLeftRightSmallTextContent(
                    descriptionRight: '${friend.distanceToUser ?? 0} m ',
                    descriptionLeft: Localize.of(context).distanceToMe,
                    rightWidget: Container()),
              ],
            ),
          ),
          const SizedBox(width: 5),
          CupertinoButton(
            child: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
            onPressed: () async {
              var action = await showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context, FriendsAction.edit);
                          },
                          child: Text(Localize.of(context).editfriend),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context, FriendsAction.delete);
                          },
                          child: Text(Localize.of(context).deletefriend),
                        )
                      ],
                    );
                  });
              if (action == FriendsAction.edit) {
                if (!mounted) return;
                var result = await EditFriendDialog.show(context,
                    friend: friend, friendDialogAction: FriendsAction.edit);
                if (result != null) {
                  if (!mounted) return;
                  context.read(friendsLogicProvider).updateFriend(
                      friend.copyWith(
                          name: result.name,
                          color: result.color,
                          isActive: result.active));
                }
              } else if (action == FriendsAction.delete) {
                if (!mounted) return;
                context
                    .read(friendsLogicProvider)
                    .deleteRelationShip(friend.friendId);
              }
            },
          ),
        ],
      ),
    );
  }
}

enum FriendsAction { addNew, addWithCode, edit, delete }

class FriendsActionModal extends StatelessWidget {
  const FriendsActionModal({super.key});

  static Future<FriendsAction?> show(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => const FriendsActionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).addnewfriend),
          onPressed: () {
            Navigator.pop(context, FriendsAction.addNew);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).addfriendwithcode),
          onPressed: () {
            Navigator.pop(context, FriendsAction.addWithCode);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(Localize.of(context).cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
