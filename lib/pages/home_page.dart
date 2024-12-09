//import 'dart:io' if (dart.library.html) 'dart.html' if (dart.library.io) 'dart.io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Icons, Colors, Scaffold, Badge, FloatingActionButton, Card, ListTile;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/app_configuration_helper.dart';
import '../helpers/logger.dart';
import '../helpers/url_launch_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/sponsors_provider.dart';
import 'home_info/event_info.dart';
import '../providers/active_event_provider.dart';
import '../providers/messages_provider.dart';
import '../providers/rest_api/onsite_state_provider.dart';
import '../providers/route_providers.dart';
import 'messages/messages_page.dart';

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
    var messageProvider = ref.watch(messagesLogicProvider);
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
      child: Scaffold(
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
                /*CupertinoSliverNavigationBar(
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
            ),*/
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
                          EventInfo(tabController: widget.tabController),
                          //kIsWeb ? EventInfoWeb() : EventInfo(),

                          Builder(builder: (context) {
                            var sponsors = ref.watch(sponsorsProvider);
                            if (sponsors.hasValue) {
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
                            if (sponsors.hasValue) {
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
                                          autoPlay: true,
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
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (sponsors
                                                          .value![index].url !=
                                                      null) {
                                                    Launch.launchUrlFromString(
                                                        sponsors.value![index]
                                                            .url!);
                                                  }
                                                },
                                                child:
                                                    Builder(builder: (context) {
                                                  return FadeInImage
                                                      .assetNetwork(
                                                    height: 50,
                                                    width: 100,
                                                    fit: BoxFit.contain,
                                                    placeholder: sponsors
                                                        .value![index]
                                                        .description,
                                                    image: sponsors
                                                        .value![index].imageUrl,
                                                    fadeOutDuration:
                                                        const Duration(
                                                            milliseconds: 150),
                                                    fadeInDuration:
                                                        const Duration(
                                                            milliseconds: 150),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      BnLog.error(
                                                          text:
                                                              'sponsor image error ${sponsors.value![index].imageUrl}) could not been loaded',
                                                          exception: error);
                                                      return Image.asset(
                                                          emptySponsorPlaceholder,
                                                          fit: BoxFit.fill);
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
      ),
    );
  }
}
