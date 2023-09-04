import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../app_settings/app_constants.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/device_info_helper.dart';
import '../../../helpers/logger.dart';
import '../../../models/friend.dart';
import '../../../pages/widgets/fast_custom_color_picker.dart';
import '../../../providers/friends_provider.dart';
import '../../../wamp/wamp_error.dart';
import '../friends_page.dart';

class EditFriendResult {
  final String name;
  final Color color;
  final String? code;
  final bool active;

  const EditFriendResult(this.name, this.color, this.code, this.active);
}

class EditFriendDialog extends StatefulWidget {
  const EditFriendDialog(
      {this.friend, this.action = FriendsAction.edit, Key? key})
      : super(key: key);

  final Friend? friend;
  final FriendsAction action;

  @override
  State<EditFriendDialog> createState() => _EditFriendDialogState();

  static Future<EditFriendResult?> show(
    BuildContext context, {
    Friend? friend,
    required FriendsAction friendDialogAction,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => EditFriendDialog(
        friend: friend,
        action: friendDialogAction,
      ),
    );
  }
}

class _EditFriendDialogState extends State<EditFriendDialog> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  String? errortext;
  String name = '';
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
    return CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(widget.action == FriendsAction.addWithCode
              ? Localize.of(context).addfriendwithcode
              : widget.friend != null
                  ? Localize.of(context).editfriend
                  : Localize.of(context).addnewfriend),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: nameController,
              placeholder: Localize.of(context).enterfriendname,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              textInputAction: TextInputAction.next,
            ),
            if (widget.action == FriendsAction.addWithCode) ...[
              const SizedBox(height: 5),
              CupertinoTextField(
                placeholder: Localize.of(context).enter6digitcode,
                maxLength: 6,
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
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    code = value;
                  });
                },
              ),
            ],
            if (errortext != null)
              FittedBox(
                child: Text(
                  errortext!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Localize.of(context).isuseractive),
                CupertinoSwitch(
                  //Show friend in Map. Tracking stays active.
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            FittedBox(
              alignment: Alignment.center,
              child: FastCustomColorPicker(
                selectedColor: color!,
                onColorSelected: (color) {
                  setState(() {
                    this.color = color;
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(Localize.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (!isLoading)
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: isValid
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          if (widget.action == FriendsAction.edit) {
                            Navigator.of(context).pop(
                                EditFriendResult(name, color!, code, isActive));
                            return;
                          }

                          if (widget.action == FriendsAction.addNew) {
                            var friend = await context
                                .read(friendsLogicProvider)
                                .addNewFriend(name, color!);
                            if (friend == null) {
                              FlutterPlatformAlert.showAlert(
                                  windowTitle: Localize.current.addnewfriend,
                                  text: Localize.current.failed);
                              return;
                            }
//workaround for IPad , crashes when more as 2 buttons in alertView
                            var isIPad = await DeviceHelper.deviceIsIPad();
                            final clickedButton =
                                await FlutterPlatformAlert.showCustomAlert(
                                    windowTitle: Localize.current
                                        .invitebyname(friend.name),
                                    text: Localize.current.tellcode(
                                        friend.name, friend.requestId),
                                    positiveButtonTitle:
                                        Localize.current.sendlink,
                                    neutralButtonTitle: Localize.current.copy,
                                    //removed - causes crash on iOS
                                    negativeButtonTitle: isIPad
                                        ? null
                                        : Localize.current.understand,
                                    windowPosition:
                                        AlertWindowPosition.screenCenter,
                                    options: FlutterPlatformAlertOption(
                                        preferMessageBoxOnWindows: true,
                                        showAsLinksOnWindows: true));
                            if (clickedButton == CustomButton.positiveButton) {
                              Share.share(
                                  Localize.current.sendlinkdescription(
                                      friend.requestId,
                                      playStoreLink,
                                      iOSAppStoreLink),
                                  subject: Localize.current.sendlink);
                            } else if (clickedButton ==
                                CustomButton.neutralButton) {
                              //Copy text to clipboard
                              await Clipboard.setData(ClipboardData(
                                  text: friend.requestId.toString()));
                            }
                            if (!mounted) return;
                            Navigator.of(context).pop(); //go back
                          } else if (widget.action ==
                              FriendsAction.addWithCode) //validate code
                          {
                            await context
                                .read(friendsLogicProvider)
                                .addFriendWithCode(name, color!, code!);
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          }
                        } on SocketException {
                          setState(() {
                            errortext = Localize.of(context).networkerror;
                            isLoading = false;
                          });
                        } on WampError {
                          setState(() {
                            errortext = Localize.of(context).invalidcode;
                            isLoading = false;
                          });
                        } catch (e) {
                          print(e);
                          FLog.error(
                              className: toString(),
                              methodName: 'friendActionDialog',
                              text: e.toString());
                          setState(() {
                            errortext = Localize.of(context).unknownerror;
                            isLoading = false;
                          });
                        }
                      }
                    : null,
                child: Text(Localize.of(context).save))
          else
            const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    color: Colors.blueGrey,
                  ),
                ]),
        ]);
  }
}
