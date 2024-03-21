import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/logger.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/images_and_links/main_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/second_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/startpoint_image_and_link_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/realtime_data_provider.dart';
import '../bladeguard/bladeguardAdvertise.dart';
import '../bladeguard/bladeguard_on_site_page.dart';
import 'app_outdated.dart';
import 'hidden_admin_button.dart';
import 'no_connection_warning.dart';

class EventInfo extends ConsumerStatefulWidget {
  const EventInfo({super.key});

  @override
  ConsumerState<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends ConsumerState<EventInfo>
    with WidgetsBindingObserver {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initEventUpdates();
      initLocation();
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
    BnLog.debug(text: 'event_info - didChangeAppLifecycleState $state');
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
    context.refresh(updateImagesAndLinksProvider);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context
          .read(activeEventProvider.notifier)
          .refresh(forceUpdate: forceUpdate);
    }

    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        if (!mounted) return;
        context.read(activeEventProvider.notifier).refresh();
      },
    );
  }

  void initLocation() async {
    await Future.delayed(const Duration(seconds: 5));
    LocationProvider.instance.refresh(forceUpdate: true);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var nextEventProvider = context.watch(activeEventProvider);
    var eventActive =
        ref.watch(realtimeDataProvider.select((rt) => rt?.eventIsActive)) ??
            false;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!kIsWeb) const ConnectionWarning(),
          if (!kIsWeb) appOutdatedWidget(context),
          if (nextEventProvider.status == EventStatus.noevent)
            HiddenAdminButton(
              child: Text(Localize.of(context).noEventPlanned,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.textStyle),
            ),
          if (nextEventProvider.status != EventStatus.noevent)
            HiddenAdminButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BladeGuardAdvertise(),
                  Text(Localize.of(context).nextEvent,
                      textAlign: TextAlign.center,
                      style: CupertinoTheme.of(context).textTheme.textStyle),
                  const SizedBox(height: 5),
                  FittedBox(
                    child: Text(
                        '${Localize.of(context).route} ${nextEventProvider.routeName}',
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
                                  nextEventProvider.getUtcIso8601DateTime),
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
                        color: nextEventProvider.status == EventStatus.cancelled
                            ? Colors.redAccent
                            : nextEventProvider.status == EventStatus.confirmed
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
                        child: Text(nextEventProvider.statusText,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .pickerTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (nextEventProvider.status == EventStatus.confirmed && !eventActive)
            const BladeGuardOnsite(),
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50, 5.0),
              child: GestureDetector(
                onTap: () async {
                  var link = context.read(mainSponsorImageAndLinkProvider).link;
                  if (link != null && link != '') {
                    var uri = Uri.parse(
                        context.read(mainSponsorImageAndLinkProvider).link!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  }
                },
                child: Builder(builder: (context) {
                  var ms = context.watch(mainSponsorImageAndLinkProvider);
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
                onTap: () async {
                  var link =
                      context.read(secondSponsorImageAndLinkProvider).link;
                  if (link != null && link != '') {
                    var uri = Uri.parse(
                        context.read(secondSponsorImageAndLinkProvider).link!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  }
                },
                child: Builder(builder: (context) {
                  var img = context.watch(secondSponsorImageAndLinkProvider);
                  var nw = context.watch(networkAwareProvider);
                  return (img.image != null &&
                          nw.connectivityStatus == ConnectivityStatus.online)
                      ? CachedNetworkImage(
                          imageUrl: img.image!,
                          placeholder: (context, url) => Image.asset(
                              secondLogoPlaceholder,
                              fit: BoxFit.fitWidth),
                          errorWidget: (context, url, error) => Image.asset(
                              secondLogoPlaceholder,
                              fit: BoxFit.fitWidth),
                        )
                      : Image.asset(secondLogoPlaceholder,
                          fit: BoxFit.fitWidth);
                }),
              ),
            ),
          ]),
          GestureDetector(
            onTap: () async {
              return;
            },
            child: Column(
              children: [
                //Don't show starting point when no event
                if (nextEventProvider.status != EventStatus.noevent)
                  Builder(builder: (context) {
                    var spp = context.watch(startpointImageAndLinkProvider);
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
                  nextEventProvider.lastupdate == null
                      ? '-'
                      : Localize.current.dateTimeIntl(
                          nextEventProvider.lastupdate as DateTime,
                          nextEventProvider.lastupdate as DateTime,
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
