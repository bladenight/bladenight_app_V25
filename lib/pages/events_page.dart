import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../models/event.dart';
import '../pages/widgets/data_loading_indicator.dart';
import '../pages/widgets/no_data_warning.dart';
import '../pages/widgets/route_dialog.dart';
import '../providers/event_providers.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _dataKey = GlobalKey();
  bool _noActualEventFound = false;
  final _pageController = PageController(viewportFraction: 1, keepPage: true);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
         _scrollToActualEvent();
    });
  }

  _scrollToActualEvent() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_dataKey.currentContext != null) {
      Scrollable.ensureVisible(_dataKey.currentContext!,
          curve: Curves.slowMiddle, alignment: 0.5);
    }
  }

  @override
  void didUpdateWidget(covariant EventsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToActualEvent();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      floatHeaderSlivers: false,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        CupertinoSliverNavigationBar(
          leading: const Icon(CupertinoIcons.ticket),
          largeTitle: Text(Localize.of(context).events),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () async {
                  context.refresh(allEventsProvider);
                },
                child: const Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            return context.refresh(allEventsProvider);
          },
        ),
      ],
      body: Builder(builder: (context) {
        var asyncEvents = context.watch(allEventsProvider);
        return asyncEvents.maybeWhen(
            skipLoadingOnRefresh: false,
            skipLoadingOnReload: false,
            data: (events) {
              if (events.rpcException != null) {
                _noActualEventFound = false;
                return NoDataWarning(onReload: () {
                  context.refresh(allEventsProvider);
                });
              }
              var pages = _buildPages(context, events);
              return SizedBox(
                width: 100,
                height: 10,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: pages.length,
                        padEnds: false,
                        clipBehavior: Clip.antiAlias,
                        itemBuilder: (_, index) {
                          return pages[index % pages.length];
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: pages.length,
                      effect: const JumpingDotEffect(
                        dotHeight: 16,
                        dotWidth: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              return const DataLoadingIndicator();
            },
            orElse: () {
              return NoDataWarning(
                onReload: () => context.refresh(allEventsProvider),
              );
            });
      }),
    );
  }

  buildPagesList(Events events) {
    if (events.events.isEmpty) {
      return Text(Localize.of(context).nodatareceived);
    }
    return _buildPages(context, events);
  }

  List<Container> _buildPages(BuildContext context, Events events) {
    var groupedEvents = events.groupByYear();
    var lst = List.generate(groupedEvents.keys.length, (pageIndex) {
      var itemsCount =
          groupedEvents[groupedEvents.keys.elementAt(pageIndex)]!.events.length;
      var pageEvents =
          groupedEvents[groupedEvents.keys.elementAt(pageIndex)]!.events;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          //   color: Colors.green.shade300,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: RefreshIndicator(
          onRefresh: () async {
            return context.refresh(allEventsProvider);
          },
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: itemsCount * 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 == 0) {
                    var event = pageEvents[(index / 2).round()];
                    var eventStartState = EventStartState.eventOver;
                    var eventOver = event.startDateUtc
                        .add(event.duration)
                        .difference(DateTime.now().toUtc())
                        .isNegative;
                    var eventActual = !eventOver &&
                        event.startDateUtc
                                .difference(DateTime.now().toUtc())
                                .inDays <
                            7;
                    var eventFuture = !eventOver &&
                        event.startDateUtc
                                .difference(DateTime.now().toUtc())
                                .inDays >
                            7;
                    if (eventActual) {
                      eventStartState = EventStartState.eventActual;
                    }
                    if (eventFuture) {
                      eventStartState = EventStartState.eventFuture;
                    }
                    if (eventActual && _noActualEventFound) {
                      _noActualEventFound = true;
                      return Container(
                          key: _dataKey,
                          child: _listTile(context, event, eventStartState));
                    }
                    return _listTile(context, event, eventStartState);
                  } else {
                    return Divider(
                      color: CupertinoTheme.of(context).primaryColor,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    );
                  }
                }),
          ),
        ),
      );
    });
    return lst;
  }
}

enum EventStartState { eventOver, eventActual, eventFuture }

Widget _listTile(
    BuildContext context, Event event, EventStartState startState) {
  //mark old actual an new events
  Color? color;
  if (startState == EventStartState.eventOver) {
    color = HiveSettingsDB.adaptiveThemeMode == AdaptiveThemeMode.light ||
            HiveSettingsDB.adaptiveThemeMode == AdaptiveThemeMode.system
        ? Colors.blueGrey
        : Colors.white70;
  }
  if (startState == EventStartState.eventActual) {
    color = CupertinoTheme.of(context).primaryColor;
  }
  if (startState == EventStartState.eventFuture) {}
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      RouteDialog.show(context, event);
    },
    child: Container(
      color: CupertinoDynamicColor.resolve(
          CupertinoColors.systemBackground, context),
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    '${startState == EventStartState.eventActual ? Localize.of(context).nextEvent : Localize.of(context).route} ${Localize.of(context).on} ',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  Localize.current
                      .dateTimeIntl(event.startDate, event.startDate),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Row(
                  children: [
                    /*Text(
                      '${Localize.of(context).route} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: color,
                      ),
                    ),*/
                    Flexible(
                      child: Text(
                        '${event.routeName} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    if (event.formatDistance != '')
                      Flexible(
                        child: Text(
                          '- ${event.formatDistance}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(children: [
            if (event.participants > 0)
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.greenAccent,
                  ),
                  const Icon(CupertinoIcons.person_2_fill),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    event.participants.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (event.status == EventStatus.pending)
              const Icon(
                CupertinoIcons.time,
                color: Colors.grey,
              ),
            if (event.status == EventStatus.cancelled)
              const Icon(
                Icons.cancel_rounded,
                color: Colors.redAccent,
              ),
            if (event.status == EventStatus.confirmed &&
                event.participants <= 0)
              const Icon(
                Icons.emoji_events_rounded,
                color: Colors.greenAccent,
              ),
            if (event.status == EventStatus.running)
              const Icon(
                Icons.run_circle_outlined,
                color: Colors.blueAccent,
              ),
            if (event.status == EventStatus.finished)
              const Icon(
                Icons.home_outlined,
                color: Colors.orange,
              ),
          ]),
          const SizedBox(
            width: 10,
          ),
          const Icon(CupertinoIcons.map),
        ],
      ),
    ),
  );
}

/*
* ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              for (var event in groupedEvents.values) {
                if (index % 2 == 0) {
                  var event = events.events[(index / 2).round()];
                  var eventStartState = EventStartState.eventOver;
                  var eventOver = event.startDateUtc
                      .add(event.duration)
                      .difference(DateTime.now().toUtc())
                      .isNegative;
                  var eventActual = !eventOver &&
                      event.startDateUtc
                              .difference(DateTime.now().toUtc())
                              .inDays <
                          7;
                  var eventFuture = !eventOver &&
                      event.startDateUtc
                              .difference(DateTime.now().toUtc())
                              .inDays >
                          7;
                  if (eventActual) {
                    eventStartState = EventStartState.eventActual;
                  }
                  if (eventFuture) {
                    eventStartState = EventStartState.eventFuture;
                  }
                  if (eventActual && noActualEventFound) {
                    noActualEventFound = true;
                    return Container(
                        key: dataKey,
                        child: _listTile(context, event, eventStartState));
                  }
                  return _listTile(context, event, eventStartState);
                } else {
                  return Divider(
                    color: CupertinoTheme.of(context).primaryColor,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  );
                }
              }
            },
          ),
          * */
