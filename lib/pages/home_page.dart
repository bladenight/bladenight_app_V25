//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';

import '../generated/l10n.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/logger.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../pages/widgets/event_info.dart';
import '../providers/active_event_provider.dart';
import '../providers/messages_provider.dart';
import '../providers/route_providers.dart';
import 'about_page.dart';
import 'messages/messages_page.dart';
import 'settings_page.dart';
import 'widgets/event_info_web.dart';
import 'widgets/intro_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.tabController});

  final CupertinoTabController tabController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    clearLog();
    if (!kIsWeb) {
      initOneSignal();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
    if (state == AppLifecycleState.inactive) {}
    if (state == AppLifecycleState.paused) {}
  }

  ///Clean up log file and delete data's older than a week
  void clearLog() async {
    try {
      await BnLog.cleanUpLogsByFilter(const Duration(days: 8));
    } catch (e) {
      BnLog.warning(text: 'Error clearing logs');
    }
  }

  void initOneSignal() async {
    if (kIsWeb) return;
    await Future.delayed(const Duration(seconds: 3)); //delay and wait
    if (Platform.isIOS) {
      if (!kIsWeb) {
        BnLog.info(
            text: ' iOS - init OneSignal PushNotifications permissions OK');
      }
      await OnesignalHandler.initPushNotifications();
      return;
    }
    //workaround for android 8.1 Nexus
    if (Platform.isAndroid &&
        await DeviceHelper.isAndroidGreaterOrEqualVersion(9)) {
      BnLog.info(
          text:
              'Android is greater than V9 OneSignal  PushNotifications permissions OK');
      await OnesignalHandler.initPushNotifications();
      return;
    }
    BnLog.info(text: 'Onesignal not available ${Platform.version}');
  }

  @override
  Widget build(BuildContext context) {
    var messageProvider = context.watch(messagesLogicProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        var tabIndex = widget.tabController.index;
        if (tabIndex == 0) {
          widget.tabController.index = 4;
        }
        widget.tabController.index -= 1;
        return;
      },
      child: CupertinoPageScaffold(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              leading: const Icon(CupertinoIcons.home),
              largeTitle: Text(Localize.of(context).home),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () async {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const MessagesPage(),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                    child: messageProvider.messages.isNotEmpty
                        ? Badge(
                            label:
                                Text(messageProvider.readMessages.toString()),
                            child: const Icon(Icons.mark_email_unread),
                          )
                        : const Icon(CupertinoIcons.envelope),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () async {
                      //_showOverlay(context, text: 'OK');
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const IntroScreen(),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                    child: const Icon(CupertinoIcons.question_circle),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const SettingsPage(),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                    child: const Icon(CupertinoIcons.settings_solid),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () async {
                      AboutPage.show(context);
                    },
                    child: const Icon(CupertinoIcons.info_circle),
                  ),
                ],
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                context.read(messagesLogicProvider).updateServerMessages();
                context.refresh(currentRouteProvider);
                context
                    .read(activeEventProvider.notifier)
                    .refresh(forceUpdate: true);
              },
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: kIsWeb ? EventInfoWeb() : EventInfo(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
