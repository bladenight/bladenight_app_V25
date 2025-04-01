//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show Icons, Colors, Scaffold, Badge, FloatingActionButton, Card;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_settings/app_constants.dart';
import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../helpers/file_name_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger/logger.dart';
import '../../helpers/notification/notification_helper.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/url_launch_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../helpers/watch_communication_helper.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/sponsors_provider.dart';
import '../widgets/sponsors.dart';
import 'event_info.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/messages_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/route_providers.dart';
import 'event_info_web.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _firstRefresh = true;

  StreamSubscription? _uniLinkStreamSubscription;
  StreamSubscription? _oneSignalOSNotificationOpenedResultSubSubscription;

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    print('App exit requested');
    BnLog.error(text: 'App exit requested');
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
        BnLog.verbose(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App paused - LocProvider instance pause updates calling');
        pauseUpdates();
        LocationProvider().setToBackground(true);
        break;
      case AppLifecycleState.hidden:
        BnLog.verbose(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App hidden - ');
        break;
      case AppLifecycleState.detached:
        BnLog.verbose(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App detached - ');
        break;
      case AppLifecycleState.inactive:
        BnLog.verbose(
            className: toString(),
            methodName: 'didChangeAppLifecycleState',
            text: 'App inactive - ');
        break;
    }
  }

  @override
  void dispose() {
    pauseUpdates();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void resumeUpdates({bool force = false}) async {
    BnLog.verbose(
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
    BnLog.verbose(
        className: toString(),
        methodName: 'pauseUpdates',
        text: 'update paused');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(messagesLogicProvider).updateServerMessages();
    });
    super.initState();

    //_initURIHandler();
    //_incomingLinkHandler();
    initWatchFlutterChannel();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb) {
        await FMTCStore(fmtcTileStoreName).manage.create();

        _openIntroScreenFirstTime();
        _openBladeguardRequestFirstTime();
        initOneSignal();
        await _initNotifications();
      }
      _initImages();
      await BnLog.cleanUpLogsByFilter(const Duration(days: 8));
    });
  }

  @override
  Widget build(BuildContext context) {
    var messageProvider = ref.watch(messagesLogicProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: (messageProvider.messages.isNotEmpty &&
                messageProvider.readMessagesCount > 0)
            ? Colors.green
            : null,
        foregroundColor: (messageProvider.messages.isNotEmpty &&
                messageProvider.readMessagesCount > 0)
            ? Colors.black
            : null,
        heroTag: 'msgActionBtn',
        onPressed: () async {
          context.pushNamed(AppRoute.messagesPage.name);
        },
        child: messageProvider.messages.isNotEmpty &&
                messageProvider.readMessagesCount > 0
            ? Badge(
                label: Text(messageProvider.readMessagesCount.toString()),
                child: const Icon(Icons.mark_email_unread),
              )
            : const Icon(CupertinoIcons.envelope),
      ),
      body: CupertinoPageScaffold(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  ref.read(messagesLogicProvider).updateServerMessages();
                  var _ = ref.refresh(currentRouteProvider);
                  ref
                      .read(activeEventProvider.notifier)
                      .refresh(forceUpdate: true);
                  ref.invalidate(bgIsOnSiteProvider);
                },
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: true,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (localTesting)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                'Warning ${kDebugMode ? 'DEBUG Mode on and' : ''} local testing is set',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (HiveSettingsDB.useCustomServer)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                  'Warning server address is ${HiveSettingsDB.customServerAddress}'),
                            ),
                          ),
                        //EventInfo(),
                        kIsWeb ? EventInfoWeb() : EventInfo(),

                        Builder(builder: (context) {
                          var sponsors = ref.watch(sponsorsProvider);
                          if (sponsors.hasValue && sponsors.value!.isNotEmpty) {
                            return Center(
                              child: Text(
                                Localize.of(context).sponsors,
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return Container();
                        }),
                        SponsorCarousel(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static int _initimgCount = 0;

  void _initImages() async {
    var imagesLoaded = false;
    if (mounted) {
      imagesLoaded = await ref.refresh(updateImagesAndLinksProvider.future);
    }
    _initimgCount++;
    if (!imagesLoaded && _initimgCount < 5) {
      await Future.delayed(const Duration(seconds: 5));
      _initImages();
    } else {
      _initimgCount = 0;
      return;
    }
  }

  void _openIntroScreenFirstTime() async {
    if (!kIsWeb && !HiveSettingsDB.hasShownIntro) {
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

  Future<bool> _initNotifications() async {
    try {
      await NotificationHelper().initialiseNotifications();
    } catch (e) {
      print('initNotifications failed + $e');
      return false;
    }
    return true;
  }
}
