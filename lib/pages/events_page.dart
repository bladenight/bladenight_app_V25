import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../generated/l10n.dart';
import '../models/event.dart';
import '../pages/widgets/no_connection_warning.dart';
import '../pages/widgets/data_loading_indicator.dart';
import '../pages/widgets/no_data_warning.dart';
import '../pages/widgets/route_dialog.dart';
import '../providers/event_providers.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(builder: (context) {
      return CupertinoPageScaffold(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              leading: const Icon(CupertinoIcons.ticket),
              largeTitle: Text(Localize.of(context).events),
              trailing: Align(
                alignment: Alignment.bottomRight,
                child: Row(
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
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                context.refresh(
                    allEventsProvider); //refresh event self//refresh route on Map
              },
            ),
            const SliverToBoxAdapter(child: ConnectionWarning()),
            Builder(builder: (context) {
              var asyncEvents = context.watch(allEventsProvider);
              return asyncEvents.maybeWhen(
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                  data: (events) {
                if (events.rpcException != null) {
                  return SliverFillRemaining(
                      child: NoDataWarning(
                    onReload: () {
                      context.refresh(allEventsProvider);
                    }
                  ));
                }
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  if (index % 2 == 0) {
                    var event = events.events[(index / 2).round()];
                    return _listTile(context, event);
                  } else {
                    return Divider(
                      color: CupertinoTheme.of(context).primaryColor,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    );
                  }
                }, childCount: events.events.length * 2 - 1));
              }, loading: () {
                return const SliverFillRemaining(
                  child: DataLoadingIndicator(),
                );
              }, orElse: () {
                return SliverFillRemaining(
                  child: NoDataWarning(
                    onReload: () => context.refresh(allEventsProvider),
                  ),
                );
              });
            }),
          ],
        ),
      );
    });
  }
}

Widget _listTile(BuildContext context, Event event) {
  //mark old actual an new events
  var eventOver =
      event.startDateUtc.difference(DateTime.now().toUtc()).isNegative;
  var eventActual = !eventOver &&
      event.startDateUtc.difference(DateTime.now().toUtc()).inDays < 7;
  var eventFuture = !eventOver &&
      event.startDateUtc.difference(DateTime.now().toUtc()).inDays > 7;
  Color? color;
  if (eventOver) {
    color = CupertinoColors.systemGrey;
  }
  if (eventActual) {
    color = CupertinoTheme.of(context).primaryColor;
  }
  if (eventFuture) {}
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      RouteDialog.show(context, event.routeName, event.formatDistance);
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
                Text(
                  '${eventActual ? Localize.of(context).nextEvent : Localize.of(context).route} ${Localize.of(context).on} ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: color,
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
                    Text(
                      '${event.routeName} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (event.formatDistance != '')
                      Text(
                        '- ${event.formatDistance}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(children: [
            if (event.status == EventStatus.pending)
              const Icon(
                CupertinoIcons.clock,
                color: Colors.grey,
              ),
            if (event.status == EventStatus.cancelled)
              const Icon(
                CupertinoIcons.clear,
                color: Colors.redAccent,
              ),
            if (event.status == EventStatus.confirmed)
              const Icon(
                CupertinoIcons.check_mark,
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
            if (event.participants > 0)
              Row(
                children: [
                  const Icon(CupertinoIcons.person_2_fill),
                  Text(event.participants.toString()),
                ],
              ),
          ]),
          const Icon(CupertinoIcons.info),
        ],
      ),
    ),
  );
}
