//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show Icons, Colors, Scaffold, Badge, FloatingActionButton, Card;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_settings/app_constants.dart';
import '../../app_settings/server_connections.dart';
import '../../helpers/file_name_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/logger.dart';
import '../../helpers/notification/notification_helper.dart';
import '../../helpers/notification/onesignal_handler.dart';
import '../../helpers/url_launch_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../helpers/watch_communication_helper.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/sponsors_provider.dart';
import 'event_info.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/messages_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/route_providers.dart';

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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(messagesLogicProvider).updateServerMessages();
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    var messageProvider = ref.watch(messagesLogicProvider);
    return Scaffold(
      floatingActionButton: messageProvider.messages.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: (messageProvider.messages.isNotEmpty &&
                      messageProvider.readMessages > 0)
                  ? Colors.green
                  : null,
              foregroundColor: (messageProvider.messages.isNotEmpty &&
                      messageProvider.readMessages > 0)
                  ? Colors.black
                  : null,
              heroTag: 'msgActionBtn',
              onPressed: () async {
                context.pushNamed(AppRoute.messagesPage.name);
              },
              child: messageProvider.messages.isNotEmpty &&
                      messageProvider.readMessages > 0
                  ? Badge(
                      label: Text(messageProvider.readMessages.toString()),
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
                        EventInfo(),
                        //kIsWeb ? EventInfoWeb() : EventInfo(),

                        Builder(builder: (context) {
                          var sponsors = ref.watch(sponsorsProvider);
                          if (sponsors.hasValue && sponsors.value!.isNotEmpty) {
                            return Center(
                              child: Text(
                                'Sponsoren',
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return Container();
                        }),

                        Builder(builder: (context) {
                          var sponsors = ref.watch(sponsorsProvider);
                          if (sponsors.hasValue && sponsors.value!.isNotEmpty) {
                            return SizedBox(
                              height: 60.0,
                              width: MediaQuery.of(context).size.width,
                              child: /*CarouselSlider(
                                      options: CarouselOptions(
                                        aspectRatio: 2.0,
                                        scrollDirection: Axis.horizontal,
                                        autoPlay: true,
                                        enlargeCenterPage: false,
                                        viewportFraction: 1,
                                      ),
                                      items: [
                                        for (var sponsor in sponsors.value!)
                                          FadeInImage.assetNetwork(
                                            height: 50,
                                            width: 100,
                                            fit: BoxFit.fitWidth,
                                            placeholder:
                                                emptySponsorPlaceholder,
                                            image: sponsor.imageUrl,
                                            fadeOutDuration: const Duration(
                                                milliseconds: 150),
                                            fadeInDuration: const Duration(
                                                milliseconds: 150),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              BnLog.error(
                                                  text:
                                                      'sponsor image error ${sponsor.imageUrl}) could not been loaded',
                                                  exception: error);
                                              return Image.asset(
                                                  emptySponsorPlaceholder,
                                                  fit: BoxFit.fitWidth);
                                            },
                                          ),
                                      ]),*/

                                  CarouselSlider.builder(
                                      options: CarouselOptions(
                                        aspectRatio: 2.0,
                                        scrollDirection: Axis.horizontal,
                                        autoPlay:
                                            (sponsors.value!.length).round() > 1
                                                ? true
                                                : false,
                                        enlargeCenterPage: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.zoom,
                                        enlargeFactor: 0.4,
                                        viewportFraction: 1,
                                      ),
                                      //controller: _sponsorScrollController,
                                      //physics: ClampingScrollPhysics(),
                                      itemCount:
                                          (sponsors.value!.length).round(),
                                      itemBuilder: (context, index, realIdx) {
                                        return Card(
                                          color: CupertinoTheme.of(context)
                                              .scaffoldBackgroundColor,
                                          //bg color for card
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (sponsors
                                                        .value![index].url !=
                                                    null) {
                                                  Launch.launchUrlFromString(
                                                      sponsors
                                                          .value![index].url!);
                                                }
                                              },
                                              child:
                                                  Builder(builder: (context) {
                                                var imageName = sponsors
                                                    .value![index].imageUrl;
                                                if (CupertinoTheme.brightnessOf(
                                                        context) ==
                                                    Brightness.light) {
                                                  imageName =
                                                      getDarkName(imageName);
                                                }
                                                return FadeInImage.assetNetwork(
                                                  //height: 80,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.66,
                                                  fit: BoxFit.contain,
                                                  placeholder: sponsors
                                                      .value![index]
                                                      .description,
                                                  image: imageName,
                                                  fadeOutDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                  fadeInDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    BnLog.warning(
                                                        text:
                                                            'The sponsor image error ${sponsors.value![index].imageUrl}) could not been loaded',
                                                        exception: error);
                                                    return Text(
                                                      sponsors.value![index]
                                                          .description,
                                                    );
                                                    /* Image.asset(
                                                        emptySponsorPlaceholder,
                                                        fit: BoxFit.fill);*/
                                                  },
                                                );
                                              }),
                                            ),
                                          ),
                                        );
                                      }),
                            );
                          }
                          return Container();
                        }),
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
