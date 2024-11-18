import 'dart:async';
import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import '../helpers/export_import_data_helper.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../helpers/logger.dart';
import '../helpers/notification/notification_helper.dart';
import '../helpers/notification/onesignal_handler.dart';
import '../helpers/watch_communication_helper.dart';
import '../providers/get_images_and_links_provider.dart';
import '../providers/location_provider.dart';
import 'bladeguard/bladeguard_page.dart';
import 'events/events_page.dart';
import 'friends/friends_page.dart';
import 'home_page.dart';
import 'map/map_page.dart';
import 'settings/settings_page.dart';
import 'widgets/intro_slider.dart';

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
  final _appLinks = AppLinks();

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
    _initURIHandler();
    _incomingLinkHandler();
    initFlutterChannel();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //_openIntroScreenFirstTime();
      _openBladeguardRequestFirstTime();
      if (!kIsWeb) {
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
    if (!kIsWeb && !HiveSettingsDB.hasShownIntro) {
      BnLog.info(
          className: 'home_screen',
          methodName: 'openIntroScreenFirstTime',
          text: 'Will open IntroScreen');

      HiveSettingsDB.setHasShownIntro(true);
      if (!mounted) return;
      await Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const IntroScreen(),
          fullscreenDialog: false,
        ),
      );
    }
  }

  void _openBladeguardRequestFirstTime() async {
    if (!kIsWeb && !HiveSettingsDB.hasShownBladeGuard) {
      BnLog.info(
          className: 'home_screen',
          methodName: 'openBladeguardRequestFirstTime',
          text: 'Will open BladeguardRequestFirstTime');

      if (!mounted) return;
      await Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const BladeGuardPage(),
          fullscreenDialog: false,
        ),
      );
      HiveSettingsDB.setHasShownBladeGuard(true);
    }
  }

  Future<void> _initURIHandler() async {
    if (kIsWeb) return;
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        Uri? initUri = await _appLinks.getInitialLink();
        print('Invoked _initURIHandler');
        if (!kIsWeb) BnLog.info(text: 'Invoked _initURIHandler $initUri');
        if (initUri == null) return;
        _handleIncomingUriResult(initUri.toString());
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
      } on PlatformException catch (ex) {
        // Platform messages may fail but we ignore the exception
        if (!kIsWeb) {
          BnLog.error(text: 'Platform exception failed to get initial uri $ex');
        }
      } on FormatException catch (err) {
        if (!kIsWeb) BnLog.error(text: 'malformed initial uri $err');
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() async {
    if (kIsWeb) return;
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _uniLinkStreamSubscription = _appLinks.uriLinkStream.listen((uri) async {
      if (!kIsWeb) BnLog.info(text: 'Received URI: $uri');
      _handleIncomingUriResult(uri.toString());

      //uri received
      //check from terminal
      //ios  /usr/bin/xcrun simctl openurl booted "bna://bladenight.app?addFriend&code=620087&name=Test"
      //android
      // ~/Library/Android/sdk/platform-tools/adb adb -s devicename shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "bna://bladenight.app?addFriend&code=620087&name=Test"'
    }, onError: (Object err) {
      print('Error occurred: $err');
    });
  }

  void _handleIncomingUriResult(String? uriString) async {
    //import friends and Id
    if (uriString == null) return;
    if (uriString.contains('?data=')) {
      importData(context, uriString);
    } else if (uriString.contains('?addFriend')) {
      tabController.index = 3;
      await addFriendWithCodeFromUrl(context, uriString);
    } else if (uriString.contains('?$specialCode=1')) {
      HiveSettingsDB.setHasSpecialRightsPrefs(true);
    } else if (uriString.contains('?$specialCode=0')) {
      HiveSettingsDB.setHasSpecialRightsPrefs(false);
    }
  }

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
            return HomePage(tabController: tabController);
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
