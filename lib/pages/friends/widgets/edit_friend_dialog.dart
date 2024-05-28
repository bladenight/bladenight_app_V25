import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../app_settings/app_constants.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/logger.dart';
import '../../../models/friend.dart';
import '../../../providers/friends_provider.dart';
import '../../../wamp/wamp_error.dart';
import '../../widgets/data_widget_left_right.dart';
import '../../widgets/no_connection_warning.dart';
import '../../widgets/scroll_quick_alert.dart';
import 'friends_action_sheet.dart';

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
    return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => EditFriendDialog(
        friend: friend,
        action: friendDialogAction,
      ),
    );
  }
}

class _EditFriendDialogState extends ConsumerState<EditFriendDialog> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  String? errorText;
  String name = '';
  bool nameOk = false;
  String? code;
  Color? color;
  bool isActive = true;
  bool isLoading = false;

  bool get isCodeValid =>
      code != null && code!.length == 6 && int.tryParse(code!) != null;

  bool get isValid =>
      name.isNotEmpty &&
      (widget.action != FriendsAction.addWithCode || isCodeValid);

  @override
  void initState() {
    super.initState();
    name = widget.friend?.name ?? '';
    color = widget.friend?.color ??
        ColorConstants.friendPickerColors[
            Random().nextInt(ColorConstants.friendPickerColors.length)];
    code = widget.friend?.requestId.toString();
    isActive = widget.friend?.isActive ?? true;
    nameController = TextEditingController(text: name);
    codeController = TextEditingController(text: code);
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
                  Navigator.of(context).pop();
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
                              isCodeValid))
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          _saveData();
                        },
                        child: const Icon(Icons.save_alt),
                      ),
                    ])
                  : Container(),
            ),
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
                    Text(
                      Localize.of(context).enterfriendname,
                      textAlign: TextAlign.start,
                    ),
                    CupertinoTextFormFieldRow(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return Localize.of(context).missingName;
                        }
                        return null;
                      },
                      decoration: const BoxDecoration(
                        color: CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.white,
                          darkColor: CupertinoColors.black,
                        ),
                      ),
                      placeholder: Localize.of(context).enterfriendname,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                          nameOk = value.isNotEmpty;
                        });
                      },
                    ),
                    if (widget.action == FriendsAction.addWithCode) ...[
                      const SizedBox(height: 5),
                      Text(
                        Localize.of(context).enter6digitcode,
                        textAlign: TextAlign.start,
                      ),
                      CupertinoTextFormFieldRow(
                        placeholder: Localize.of(context).enter6digitcode,
                        maxLength: 6,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 6) {
                            return Localize.of(context).enter6digitcode;
                          }
                          return null;
                        },
                        controller: codeController,
                        decoration: BoxDecoration(
                          color: const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.white,
                            darkColor: CupertinoColors.black,
                          ),
                          border: Border.all(
                            color: code == null || isCodeValid
                                ? const CupertinoDynamicColor.withBrightness(
                                    color: Color(0x33000000),
                                    darkColor: Color(0x33FFFFFF),
                                  )
                                : CupertinoColors.destructiveRed,
                            width: 0.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            code = value;
                          });
                        },
                      ),
                    ],
                    if (errorText != null)
                      FittedBox(
                        child: Text(
                          errorText!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: CupertinoColors.destructiveRed,
                          ),
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
                    const SizedBox(height: 10),
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
                                      isCodeValid)
                              ? () {
                                  _saveData();
                                }
                              : null,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(Localize.of(context).save)),
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
                            Navigator.of(context).pop();
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
          await ScrollQuickAlert.show(
              context: context,
              showCancelBtn: true,
              showConfirmBtn: false,
              type: QuickAlertType.error,
              title: Localize.current.addnewfriend,
              text: Localize.current.failed,
              cancelBtnText: Localize.current.cancel);
          return;
        }
        if (friend == null) return;
        if (!mounted) return;
        await ScrollQuickAlert.show(
            context: context,
            showCancelBtn: true,
            type: QuickAlertType.warning,
            barrierDismissible: true,
            title: Localize.current.invitebyname(friend.name),
            text: Localize.current.tellcode(friend.name, friend.requestId),
            confirmBtnText: Localize.current.sendlink,
            cancelBtnText: Localize.current.copy,
            onConfirmBtnTap: () {
              Share.share(
                  Localize.current.sendlinkdescription(
                      friend.requestId, playStoreLink, iOSAppStoreLink),
                  subject: Localize.current.sendlink);
              Navigator.pop(context);
            },
            onCancelBtnTap: () async {
              await Clipboard.setData(
                  ClipboardData(text: friend.requestId.toString()));
              if (!mounted) return;
              Navigator.pop(context);
            });
        if (!mounted) return;
        Navigator.of(context).pop(); //go back
      } else if (widget.action == FriendsAction.addWithCode) //validate code
      {
        var _ = await ref
            .read(friendsLogicProvider)
            .addFriendWithCode(name, color!, code!);
        if (!mounted) {
          return;
        } else {
          Navigator.of(context).pop();
        }
      }
    } on SocketException {
      setState(() {
        errorText = Localize.of(context).networkerror;
        isLoading = false;
      });
    } on WampError {
      setState(() {
        errorText = Localize.of(context).invalidcode;
        isLoading = false;
      });
    } catch (e) {
      print(e);
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
