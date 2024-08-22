//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../generated/l10n.dart';
import '../pages/widgets/event_info.dart';
import '../providers/active_event_provider.dart';
import '../providers/messages_provider.dart';
import '../providers/rest_api/onsite_state_provider.dart';
import '../providers/route_providers.dart';
import 'about_page.dart';
import 'messages/messages_page.dart';
import 'settings_page.dart';
import 'widgets/event_info_web.dart';
import 'widgets/intro_slider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.tabController});

  final CupertinoTabController tabController;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(messagesLogicProvider).updateServerMessages();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(messagesLogicProvider).updateServerMessages();
    }
    if (state == AppLifecycleState.inactive) {}
    if (state == AppLifecycleState.paused) {}
  }

  @override
  Widget build(BuildContext context) {
    var messageProvider = context.watch(messagesLogicProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
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
                    child: messageProvider.messages.isNotEmpty &&
                            messageProvider.readMessages > 0
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
                ref.read(messagesLogicProvider).updateServerMessages();
                var _ = ref.refresh(currentRouteProvider);
                ref
                    .read(activeEventProvider.notifier)
                    .refresh(forceUpdate: true);
                var __ = ref.refresh(bgIsOnSiteProvider);
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
