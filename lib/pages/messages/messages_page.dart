import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../helpers/url_launch_helper.dart';
import '../../models/external_app_message.dart';
import '../../pages/widgets/data_widget_left_right_small_text.dart';
import '../../pages/widgets/no_connection_warning.dart';
import '../../providers/messages_provider.dart';
//import 'widgets/show_message_dialog.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessagesPage();
}

class _MessagesPage extends ConsumerState with WidgetsBindingObserver {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchTextController.text = context.read(messageNameProvider);
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
      context.read(messagesLogicProvider).reloadMessages();
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
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Icon(CupertinoIcons.back),
            ),
            largeTitle: Text(Localize.of(context).messages),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: const Icon(CupertinoIcons.trash),
                      onPressed: () async {
                        final clickedButton =
                            await FlutterPlatformAlert.showCustomAlert(
                                windowTitle:
                                    Localize.current.clearMessagesTitle,
                                text: Localize.current.clearMessages,
                                positiveButtonTitle: Localize.current.yes,
                                neutralButtonTitle: Localize.current.cancel,
                                windowPosition:
                                    AlertWindowPosition.screenCenter,
                                options: FlutterPlatformAlertOption(
                                    preferMessageBoxOnWindows: true,
                                    showAsLinksOnWindows: true));
                        if (clickedButton == CustomButton.positiveButton) {
                          if (!context.mounted) return;
                          await context
                              .read(messagesLogicProvider)
                              .clearMessages();
                        }
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () async {
                      await context
                          .read(messagesLogicProvider)
                          .reloadMessages();
                    },
                    child: const Icon(CupertinoIcons.refresh),
                  ),
                ],
              ),
            ),

          CupertinoSliverRefreshControl(
            onRefresh: () async {
              return context.read(messagesLogicProvider).updateServerMessages();
            },
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
                      context.read(messageNameProvider.notifier).state = value;
                    },
                    onSubmitted: (value) {
                      context.read(messageNameProvider.notifier).state = value;
                    },
                    onSuffixTap: () {
                      context.read(messageNameProvider.notifier).state = '';
                      _searchTextController.text = '';
                    },
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: FractionallySizedBox(
                widthFactor: 0.9, child: ConnectionWarning()),
          ),
          Builder(builder: (context) {
            var messages = context.watch(filteredMessages);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index % 2 == 0) {
                    var message = messages[(index / 2).round()];
                    return Dismissible(
                      key: ObjectKey(message.uid),
                      child: _messageRow(context, message),
                      confirmDismiss: (DismissDirection direction) async {
                        if (direction == DismissDirection.endToStart) {
                          var deleteResult =
                              await FlutterPlatformAlert.showCustomAlert(
                                  windowTitle:
                                      Localize.of(context).deleteMessage,
                                  text:
                                      '${Localize.of(context).delete}: ${message.body}',
                                  iconStyle: IconStyle.warning,
                                  positiveButtonTitle: Localize.current.delete,
                                  negativeButtonTitle: Localize.current.cancel);
                          if (deleteResult == CustomButton.positiveButton) {
                            if (!context.mounted) return false;
                            context
                                .read(messagesLogicProvider)
                                .deleteMessage(message);
                          }
                        }
                        if (direction == DismissDirection.startToEnd) {
                          if (!context.mounted) return false;
                          await context
                              .read(messagesLogicProvider)
                              .setReadMessage(message, !message.read);
                        }
                        return null; /*else {
                            var result = await EditMessageDialog.show(context,
                                messageDialogAction: MessagesAction.edit,
                                message: message);
                            if (result == null || !mounted) return false;
                            context.read(messagesLogicProvider).updateMessage(
                                message.copyWith(
                                    name: result.name,
                                    color: result.color,
                                    isActive: result.active));

                          setState(() {});
                          return false; //always return true when list not changed
                          }*/
                      },
                      background: Container(
                          color: message.read
                              ? Colors.greenAccent
                              : Colors.yellowAccent,
                          child: CupertinoListTile(
                            title: Text(message.read
                                ? Localize.of(context).unreadMessage
                                : Localize.of(context).readMessage),
                            leading: message.read
                                ? const Icon(Icons.mark_email_unread,
                                    color: Colors.white, size: 36.0)
                                : const Icon(Icons.mark_email_read,
                                    color: Colors.white, size: 36.0),
                          )),
                      secondaryBackground: Container(
                          color: Colors.redAccent,
                          child: CupertinoListTile(
                              title: Text(Localize.of(context).deleteMessage),
                              trailing: const Icon(Icons.delete,
                                  color: Colors.white, size: 36.0))),
                    );
                  } else {
                    return Divider(
                      color: CupertinoTheme.of(context).primaryColor,
                      height: 1,
                    );
                  }
                },
                childCount: (messages.length * 2) - 1,
              ),
            );
          }),
        ],
      ),
    );
  }

  _messageRow(BuildContext context, ExternalAppMessage message) {
    return Container(
      color: message.read ? null : Colors.grey,
      padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 5),
      child: Row(
        children: [
          message.read
              ? const Icon(Icons.mark_email_read)
              : const Icon(Icons.mark_email_unread),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                DataWidgetLeftRightSmallTextContent(
                    descriptionRight: Localize.of(context).dateTimeSecIntl(
                        DateTime.fromMillisecondsSinceEpoch(message.timeStamp),
                        DateTime.fromMillisecondsSinceEpoch(message.timeStamp)),
                    descriptionLeft: Localize.of(context).on,
                    rightWidget: Container()),
                Text(message.title,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                Divider(
                  color: CupertinoTheme.of(context).primaryColor,
                  height: 1,
                ),
                Text(
                  message.body,
                ),
                if (message.button1Text != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.all(2),
                        minSize: 0,
                        onPressed: () async {
                          if (message.button1Link != null &&
                              message.button1Link != '') {
                            Launch.launchUrlFromString(message.button1Link!);
                          }
                        },
                        child: Text(message.button1Text!),
                      ),
                    ),
                  ),
                if (message.button2Text != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.all(2),
                        minSize: 0,
                        onPressed: () async {
                          if (message.button2Link != null &&
                              message.button2Link != '') {
                            Launch.launchUrlFromString(message.button2Link!);
                          }
                        },
                        child: Text(message.button2Text!),
                      ),
                    ),
                  ),
                if (message.button3Text != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.all(2),
                        minSize: 0,
                        onPressed: () async {
                          if (message.button3Link != null &&
                              message.button3Link != '') {
                            Launch.launchUrlFromString(message.button3Link!);
                          }
                        },
                        child: Text(message.button3Text!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          if (message.url != null)
            CupertinoButton(
              child: const Icon(CupertinoIcons.globe),
              onPressed: () async {
                if (message.url != null) {
                  Launch.launchUrlFromString(message.url!);
                }
              },
            ),
        ],
      ),
    );
  }
}

enum MessagesAction { edit, delete }

class MessagesActionModal extends StatelessWidget {
  const MessagesActionModal({super.key});

  static Future<MessagesAction?> show(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => const MessagesActionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: const [],
      cancelButton: CupertinoActionSheetAction(
        child: Text(Localize.of(context).cancel),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
