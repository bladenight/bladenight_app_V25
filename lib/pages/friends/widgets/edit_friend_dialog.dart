import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../app_settings/app_constants.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/logger.dart';
import '../../../models/friend.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../../providers/friends_provider.dart';
import '../../../providers/network_connection_provider.dart';
import '../../../wamp/wamp_exception.dart';
import '../../widgets/common_widgets/data_widget_left_right.dart';
import '../../widgets/common_widgets/no_connection_warning.dart';
import '../../widgets/input/number_input_widget.dart';
import '../../widgets/input/text_input_widget.dart';

class EditFriendResult {
  final String name;
  final Color color;
  final String? code;
  final bool active;

  const EditFriendResult(this.name, this.color, this.code, this.active);
}

class EditFriendDialog extends ConsumerStatefulWidget {
  const EditFriendDialog(
      {this.friend, this.action = FriendsAction.edit, super.key});

  final Friend? friend;
  final FriendsAction action;

  @override
  ConsumerState<EditFriendDialog> createState() => _EditFriendDialogState();

  static Future<EditFriendResult?> show(
    BuildContext context, {
    Friend? friend,
    required FriendsAction friendDialogAction,
  }) async {
    var queryParameters = {'action': friendDialogAction.name};
    if (friend != null) {
      queryParameters['friend'] = friend.toJson();
    }
    return context.pushNamed(AppRoute.editFriendDialog.name,
        queryParameters: queryParameters);
  }
}

class _EditFriendDialogState extends ConsumerState<EditFriendDialog>
    with WidgetsBindingObserver {
  String? errorText;
  String name = '';
  bool nameOk = false;
  bool codeIsValid = false;
  String? code;
  Color? color;
  bool isActive = true;
  bool isLoading = false;

  bool get isCodeValid =>
      code != null && code!.length == 6 && int.tryParse(code!) != null;

  bool get isValid =>
      name.isNotEmpty &&
      (widget.action != FriendsAction.addWithCode || codeIsValid);

  @override
  void initState() {
    super.initState();
    name = widget.friend?.name ?? '';
    color = widget.friend?.color ??
        ColorConstants.friendPickerColors[
            Random().nextInt(ColorConstants.friendPickerColors.length)];
    code = widget.friend?.requestId.toString();
    isActive = widget.friend?.isActive ?? true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color ??= widget.friend?.color ??
        ColorConstants.friendPickerColors[
            Random().nextInt(ColorConstants.friendPickerColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    nameOk = name.isNotEmpty;
    return CupertinoPageScaffold(
      child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () async {
                  context.pop();
                },
                child: const Icon(CupertinoIcons.back),
              ),
              largeTitle: Text(widget.action == FriendsAction.addWithCode
                  ? Localize.of(context).addfriendwithcode
                  : widget.friend != null
                      ? Localize.of(context).editfriend
                      : Localize.of(context).addnewfriend),
              trailing: !isLoading &&
                      ((nameOk && widget.action != FriendsAction.addWithCode) ||
                          (nameOk &&
                              widget.action == FriendsAction.addWithCode &&
                              codeIsValid))
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          _saveData();
                        },
                        child: const Icon(Icons.save_alt_outlined),
                      ),
                    ])
                  : Container(),
            ),
            if (ref.watch(networkAwareProvider).connectivityStatus !=
                ConnectivityStatus.wampConnected)
              const SliverToBoxAdapter(
                child: FractionallySizedBox(
                    widthFactor: 0.9, child: ConnectionWarning()),
              ),
            //if (!isLoading)
            SliverToBoxAdapter(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  children: [
                    TextInputWidget(
                      header: Localize.current.enterfriendname,
                      placeholder: Localize.current.enterfriendname,
                      value: name,
                      minLength: 1,
                      onChanged: (value) {
                        name = value;
                        setState(() {
                          nameOk = value.isNotEmpty;
                        });
                      },
                    ),
                    if (widget.action == FriendsAction.addWithCode) ...[
                      NumberInputWidget(
                        header: Localize.current.enter6digitcode,
                        placeholder: Localize.current.enter6digitcode,
                        code: '',
                        onChanged: (value) {
                          code = value;
                          setState(() {
                            codeIsValid = isCodeValid;
                          });
                        },
                      )
                    ],
                    if (errorText != null)
                      Text(
                        maxLines: 3,
                        errorText!,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    const SizedBox(height: 5),
                    DataLeftRightContent(
                      descriptionLeft: Localize.of(context).isuseractive,
                      descriptionRight: '',
                      rightWidget: CupertinoSwitch(
                        //Show friend in Map. Tracking stays active.
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    ColorPicker(onColorChanged: (c) {
                      setState(() {
                        color = c;
                      });
                    }),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: CupertinoButton(
                        color: Colors.greenAccent,
                        onPressed: !isLoading &&
                                    (nameOk &&
                                        widget.action !=
                                            FriendsAction.addWithCode) ||
                                (nameOk &&
                                    widget.action ==
                                        FriendsAction.addWithCode &&
                                    codeIsValid)
                            ? () {
                                _saveData();
                              }
                            : null,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(Localize.of(context).ok),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: CupertinoButton(
                          color: Colors.redAccent,
                          child: Text(Localize.of(context).cancel),
                          onPressed: () {
                            context.pop();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  _saveData() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.action == FriendsAction.edit) {
        Navigator.of(context)
            .pop(EditFriendResult(name, color!, code, isActive));
        return;
      }

      if (widget.action == FriendsAction.addNew) {
        var friend =
            await ref.read(friendsLogicProvider).addNewFriend(name, color!);
        if (friend == null && mounted) {
          setState(() {
            errorText =
                '${Localize.of(context).addnewfriend} ${Localize.of(context).failed}';
            isLoading = false;
          });
          return;
        }
        if (friend == null) return;
        if (!mounted) return;
        await QuickAlert.show(
            context: context,
            showCancelBtn: true,
            type: QuickAlertType.warning,
            barrierDismissible: true,
            title:
                '${Localize.current.invitebyname(friend.name)}  Code:${friend.requestId}',
            text: Localize.current.tellcode(friend.name, friend.requestId),
            confirmBtnText: Localize.current.sendlink,
            cancelBtnText: Localize.current.copy,
            onConfirmBtnTap: () {
              Share.share(
                  Localize.current.sendlinkdescription(
                      friend.requestId, playStoreLink, iOSAppStoreLink),
                  subject: Localize.current.sendlink);
              context.pop();
            },
            onCancelBtnTap: () async {
              await Clipboard.setData(
                  ClipboardData(text: friend.requestId.toString()));
              if (!mounted) return;
              context.pop();
            });
        if (!mounted) return;
        context.pop(); //go back
      } else if (widget.action == FriendsAction.addWithCode) //validate code
      {
        var result = await ref
            .read(friendsLogicProvider)
            .addFriendWithCode(name, color!, code!);
        if (result is String && mounted) {
          setState(() {
            errorText =
                '${Localize.of(context).addfriendwithcode} ${Localize.of(context).failed} $result';
            isLoading = false;
          });
          return;
        }
        if (!mounted) {
          return;
        } else {
          context.pop();
        }
      }
    } on SocketException {
      setState(() {
        errorText = Localize.of(context).networkerror;
        isLoading = false;
      });
    } on WampException {
      setState(() {
        errorText = Localize.of(context).invalidcode;
        isLoading = false;
      });
    } catch (e) {
      BnLog.error(
          className: toString(),
          methodName: 'friendActionDialog',
          text: e.toString());
      setState(() {
        errorText = Localize.of(context).unknownerror;
        isLoading = false;
      });
    }
  }
}
