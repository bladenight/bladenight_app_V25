import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_settings/app_constants.dart';
import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import '../helpers/export_import_data_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../helpers/watch_communication_helper.dart';
import '../providers/app_start_and_router/go_router.dart';
import '../providers/get_images_and_links_provider.dart';
import '../providers/location_provider.dart';
import 'events/events_page.dart';
import 'friends/friends_page.dart';
import 'home_info/home_page.dart';
import 'map/map_page.dart';
import 'settings/settings_page.dart';

bool _initialURILinkHandled = false;

class HomeScreen extends ConsumerStatefulWidget {
  static const String homeRouteName = '/homeScreen';

  const HomeScreen({super.key, int tabIndex = 0});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  //added deep links bna.bladenight.app
  bool _firstRefresh = true;

  StreamSubscription? _uniLinkStreamSubscription;
  StreamSubscription? _oneSignalOSNotificationOpenedResultSubSubscription;
  late CupertinoTabController tabController;

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    print('App exit requested');
    BnLog.info(text: 'App exit requested');
    BnLog.flush();
    return AppExitResponse.cancel;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BnLog.debug(text: 'home_screen - didChangeAppLifecycleState $state');
    switch (state) {
      case AppLifecycleState.resumed:
        resumeUpdates(force: true);
        LocationProvider().setToBackground(false);
        break;
      case AppLifecycleState.paused:
        BnLog.trace(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App paused - LocProvider instance pause updates calling');
        pauseUpdates();
        LocationProvider().setToBackground(true);
        break;
      case AppLifecycleState.hidden:
        BnLog.trace(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App hidden - ');
        break;
      case AppLifecycleState.detached:
        BnLog.trace(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App detached - ');
        break;
      case AppLifecycleState.inactive:
        BnLog.trace(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App inactive - ');
        break;
    }
  }

  @override
  void dispose() {
    pauseUpdates();
    _uniLinkStreamSubscription?.cancel();
    _oneSignalOSNotificationOpenedResultSubSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }

  void resumeUpdates({bool force = false}) async {
    BnLog.trace(
        className: toString(),
        methodName: 'pauseUpdates',
        text: 'update resumed');
    if (force || _firstRefresh) {
      LocationProvider().refreshRealtimeData(forceUpdate: force);
      _firstRefresh = false;
    }
    LocationProvider().startRealtimeUpdateSubscriptionIfNotTracking();
  }

  void pauseUpdates() async {
    LocationProvider().stopRealtimedataSubscription;
    BnLog.trace(
        className: toString(),
        methodName: 'pauseUpdates',
        text: 'update paused');
  }

  Future<void> _quit() async {
    const AppExitType exitType =
        AppExitType.required; // or AppExitType.cancelable;

    await ServicesBinding.instance.exitApplication(exitType);
  }

  @override
  void initState() {
    BnLog.info(
        className: 'home_screen',
        methodName: 'initState ',
        text: 'App started');
    super.initState();
    if (kIsWeb) {
      tabController = CupertinoTabController(initialIndex: 1)
        ..addListener(() {
          BnLog.info(
              className: 'home_screen',
              methodName: 'tabControllerListener',
              text: 'tabController selected index ${tabController.index}');
        });
    } else {
      tabController = CupertinoTabController(initialIndex: 0)
        ..addListener(() {
          BnLog.debug(
              className: 'home_screen',
              methodName: 'tabControllerListener',
              text: 'tabController selected index ${tabController.index}');
        });
    }
    _initImages();
    //_initURIHandler();
    //_incomingLinkHandler();
    initWatchFlutterChannel();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb) {
        await FMTCStore(fmtcTileStoreName).manage.create();
        _openIntroScreenFirstTime();
        _openBladeguardRequestFirstTime();
        await initOneSignal();
        await _initNotifications();
      }
      await BnLog.cleanUpLogsByFilter(const Duration(days: 8));
    });
  }

  Future<bool> _initNotifications() async {
    try {
      await NotificationHelper().initialiseNotifications();
    } catch (e) {
      print('initNotifications failed + $e');
      return false;
    }
    return true;
  }

  void _initImages() async {
    var imagesLoaded = false;
    if (mounted) {
      imagesLoaded = await ref.refresh(updateImagesAndLinksProvider.future);
    }
    if (!imagesLoaded) {
      await Future.delayed(const Duration(seconds: 5));
      _initImages();
    }
  }

  void _openIntroScreenFirstTime() async {
    if (!kIsWeb && !HiveSettingsDB.hasShownIntro || localTesting) {
      BnLog.info(
          className: 'home_screen',
          methodName: 'openIntroScreenFirstTime',
          text: 'Opening IntroScreen');
      HiveSettingsDB.setHasShownIntro(true);
      if (!mounted) return;
      await context.pushNamed(AppRoute.introScreen.name);
    }
  }

  void _openBladeguardRequestFirstTime() async {
    if (!kIsWeb && !HiveSettingsDB.hasShownBladeGuard) {
      BnLog.info(
          className: 'home_screen',
          methodName: 'openBladeguardRequestFirstTime',
          text: 'Opening BladeguardRequestFirstTime');
      if (!mounted) return;
      await context.pushNamed(AppRoute.bladeguard.name);
      HiveSettingsDB.setHasShownBladeGuard(true);
    }
  }

  /*
  void _handleIncomingUriResult(String? uriString) async {
    //import friends and Id
    if (uriString == null) return;
    if (uriString.contains('?data=')) {
      importData(context, uriString);
    } else if (uriString.contains('?addFriend')) {
      tabController.index = 3;
      await addFriendWithCodeFromUrl(context, uriString);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: tabController,
      tabBar: CupertinoTabBar(
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            label: Localize.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.map),
            label: Localize.of(context).map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.ticket),
            label: Localize.of(context).events,
          ),
          if (!kIsWeb)
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.group),
              label: Localize.of(context).friends,
            ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings_solid),
            label: Localize.of(context).settings,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return HomePage();
          case 1:
            return const MapPage();
          case 2:
            return const EventsPage();
          case 3:
            if (!kIsWeb) {
              return const FriendsPage();
            }
            return const SettingsPage();
          case 4:
            if (!kIsWeb) {
              return const SettingsPage();
            }
            return Container();
          /*var ssp = ref.watch(BladeguardLinkImageAndLink.provider);
              return ssp.link == null ? Container() : BladeGuardPage();*/
          default:
            return Container();
        }
      },
    );
  }
}
