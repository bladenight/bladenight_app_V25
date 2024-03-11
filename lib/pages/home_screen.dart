import 'dart:async';

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
import '../helpers/watch_communication_helper.dart';
import '../providers/get_images_and_links_provider.dart';
import 'bladeguard/bladeguard_page.dart';
import 'events_page.dart';
import 'friends/friends_page.dart';
import 'home_page.dart';
import 'map/map_page.dart';
import 'settings_page.dart';
import 'widgets/intro_slider.dart';

bool _initialURILinkHandled = false;

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/homeScreen';

  const HomeScreen({super.key, int tabIndex = 0});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //added deep links bna.bladenight.app

  StreamSubscription? _uniLinkStreamSubscription;
  StreamSubscription? _oneSignalOSNotificationOpenedResultSubSubscription;
  late CupertinoTabController tabController;
  final _appLinks = AppLinks();

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
          if (!kIsWeb) {
            BnLog.info(
                className: 'home_screen',
                methodName: 'tabControllerListener',
                text: 'tabController selected index ${tabController.index}');
          }
        });
    } else {
      tabController = CupertinoTabController(initialIndex: 0)
        ..addListener(() {
          if (!kIsWeb) {
            BnLog.debug(
                className: 'home_screen',
                methodName: 'tabControllerListener',
                text: 'tabController selected index ${tabController.index}');
          }
        });
    }
    _initImages();
    _initURIHandler();
    _incomingLinkHandler();
    initFlutterChannel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openIntroScreenFirstTime();
      _openBladeguardRequestFirstTime();
    });
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
    }
  }

  @override
  void dispose() {
    _uniLinkStreamSubscription?.cancel();
    _oneSignalOSNotificationOpenedResultSubSubscription?.cancel();
    tabController.dispose();
    super.dispose();
  }

  Future<void> _initURIHandler() async {
    if (kIsWeb) return;
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        Uri? initUri = await _appLinks.getInitialAppLink();
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
    _uniLinkStreamSubscription = _appLinks.allUriLinkStream.listen((uri) async {
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
      importData(uriString);
    } else if (uriString.contains('?addFriend')) {
      tabController.index = 3;
      await addFriendWithCodeFromUrl(context, uriString);
    } else if (uriString.contains('?$specialCode=1')) {
      HiveSettingsDB.setSpecialRightsPrefs(true);
    } else if (uriString.contains('?$specialCode=0')) {
      HiveSettingsDB.setSpecialRightsPrefs(false);
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
          /*var ssp = context.watch(BladeguardLinkImageAndLink.provider);
              return ssp.link == null ? Container() : BladeGuardPage();*/
          default:
            return Container();
        }
      },
    );
  }
}
