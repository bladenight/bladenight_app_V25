//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';

import '../generated/l10n.dart';
import '../helpers/device_info_helper.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../pages/widgets/event_info.dart';
import '../pages/widgets/event_info_web.dart';
import '../pages/widgets/intro_slider.dart';
import '../providers/active_event_notifier_provider.dart';
import '../providers/route_providers.dart';
import 'about_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.tabController}) : super(key: key);
  final CupertinoTabController tabController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (!kIsWeb) {
      clearLog();
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
    if (!kIsWeb) return;
    try {
      var date = DateTime.now().millisecondsSinceEpoch;
      var weekBefore = date - 604800000;
      var filters =
          Filters.generateFilters(endTimeInMillis: weekBefore); //691200000);
      await FLog.deleteAllLogsByFilter(filters: filters);
    } catch (e) {
      FLog.warning(text: 'Error clearing logs');
    }
  }

  void initOneSignal() async {
    if (!kIsWeb) return;
    if (Platform.isIOS) {
      if (!kIsWeb) {
        FLog.info(
            text: ' iOS - init OneSignal PushNotifications permissions OK');
      }
      await initPushNotifications();
      return;
    }
    //workaround for android 8.1 Nexus
    if (Platform.isAndroid &&
        await DeviceHelper.isAndroidGreaterOrEqualVersion(9)) {
      if (!kIsWeb) {
        FLog.info(
            text:
                ' Android is greater than V9 OneSignal  PushNotifications permissions OK');
      }
      await initPushNotifications();
      return;
    }
    if (!kIsWeb) {
      FLog.info(text: 'Onesignal not available ${Platform.version}  ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        var tabIndex = widget.tabController.index;
        if (tabIndex == 0) {
          widget.tabController.index = 4;
        }
        widget.tabController.index -= 1;
        return Future(() => false);
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
              trailing: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () async {
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
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                context.refresh(currentRouteProvider);
                context.read(activeEventProvider).refresh(forceUpdate: true);
              },
            ),
            Builder(builder: (context) {
              return const SliverFillRemaining(
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
