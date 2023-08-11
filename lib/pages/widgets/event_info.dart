import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../helpers/url_launch_helper.dart';
import '../../models/event.dart';
import '../../providers/active_event_notifier_provider.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/images_and_links/main_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/second_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/startpoint_image_and_link_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import 'app_outdated.dart';
import 'hidden_admin_button.dart';
import 'no_connection_warning.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({Key? key}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> with WidgetsBindingObserver {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initEventUpdates();
      //call on first start
      //
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!kIsWeb) {
      FLog.debug(text: 'event_info - didChangeAppLifecycleState $state');
    }
    if (state == AppLifecycleState.resumed) {
      initEventUpdates(forceUpdate: true);
      context.read(locationProvider).refresh(forceUpdate: true);
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _updateTimer?.cancel();
    }
  }

  void initEventUpdates({forceUpdate = false}) async {
    // first start
    context.read(activeEventProvider).refresh(forceUpdate: forceUpdate);
    context.refresh(updateImagesAndLinksProvider);
    //await Future.delayed(const Duration(seconds: 5));
    LocationProvider.instance.refresh(forceUpdate: true);
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        if (!mounted) return;
        context.read(activeEventProvider).refresh();
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var nextEventProvider = context.watch(activeEventProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!kIsWeb) appOutdatedWidget(context),
          if (nextEventProvider.event.status == EventStatus.noevent)
            HiddenAdminButton(
              child: Text(Localize.of(context).noEventPlanned,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.textStyle),
            ),
          if (nextEventProvider.event.status != EventStatus.noevent)
            HiddenAdminButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Localize.of(context).nextEvent,
                      textAlign: TextAlign.center,
                      style: CupertinoTheme.of(context).textTheme.textStyle),
                  const SizedBox(height: 5),
                  FittedBox(
                    child: Text(
                        '${Localize.of(context).route} ${nextEventProvider.event.routeName}',
                        textAlign: TextAlign.center,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
                    child: FittedBox(
                      child: Text(
                          DateFormatter(Localize.of(context))
                              .getLocalDayDateTimeRepresentation(
                                  nextEventProvider
                                      .event.getUtcIso8601DateTime),
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navLargeTitleTextStyle),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: nextEventProvider.event.status ==
                                EventStatus.cancelled
                            ? Colors.redAccent
                            : nextEventProvider.event.status ==
                                    EventStatus.confirmed
                                ? Colors.green
                                : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(nextEventProvider.event.statusText,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .pickerTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 1,
          ),
          if (!kIsWeb) const ConnectionWarning(),
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50, 5.0),
              child: GestureDetector(
                onTap: () {
                  var link =
                      context.read(MainSponsorImageAndLink.provider).link;
                  if (link != null && link != '') {
                    Launch.launchUrlFromString(
                        context.read(MainSponsorImageAndLink.provider).link!);
                  }
                },
                child: Builder(builder: (context) {
                  var ms = context.watch(MainSponsorImageAndLink.provider);
                  var nw = context.watch(networkAwareProvider);
                  return (ms.image != null &&
                          nw.connectivityStatus == ConnectivityStatus.online)
                      ? CachedNetworkImage(
                          imageUrl: ms.image!,
                          placeholder: (context, url) => Image.asset(
                              mainSponsorPlaceholder,
                              fit: BoxFit.fitWidth),
                          errorWidget: (context, url, error) => Image.asset(
                              mainSponsorPlaceholder,
                              fit: BoxFit.fitWidth),
                        )
                      : Image.asset(mainSponsorPlaceholder,
                          fit: BoxFit.fitWidth);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 1.0, 50, 1.0),
              child: GestureDetector(
                onTap: () {
                  var link =
                      context.read(SecondSponsorImageAndLink.provider).link;
                  if (link != null && link != '') {
                    Launch.launchUrlFromString(
                        context.read(SecondSponsorImageAndLink.provider).link!);
                  }
                },
                child: Builder(builder: (context) {
                  return Image.asset(secondLogoPlaceholder,
                      fit: BoxFit.fitWidth);
                }),
              ),
            ),
          ]),
          GestureDetector(
            onTap: () async {
              context.read(activeEventProvider).refresh();
              context.refresh(updateImagesAndLinksProvider);
              var link = context.read(StartPointImageAndLink.provider).link;
              if (link != null && link != '') {
                Launch.launchUrlFromString(
                    context.read(StartPointImageAndLink.provider).link!);
              }
            },
            child: Column(
              children: [
                //Don't show starting point when no event
                if (nextEventProvider.event.status != EventStatus.noevent)
                  Builder(builder: (context) {
                    var spp = context.watch(StartPointImageAndLink.provider);
                    return spp.text != null
                        ? FittedBox(
                            child: Text(
                              spp.text!,
                              maxLines: 10,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CupertinoTheme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : Container();
                  }),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  Localize.of(context).lastupdate,
                  style: const TextStyle(
                    color: CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.systemGrey,
                      darkColor: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
                Text(
                  nextEventProvider.event.lastupdate == null
                      ? '-'
                      : Localize.current.dateTimeIntl(
                          nextEventProvider.event.lastupdate as DateTime,
                          nextEventProvider.event.lastupdate as DateTime,
                        ),
                  style: const TextStyle(
                    color: CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.systemGrey,
                      darkColor: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );

    /* return NoDataWarning(
        onReload: () => context.read(activeEventProvider).refresh(),
      );*/
  }
}
