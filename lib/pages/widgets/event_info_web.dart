import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/logger.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../helpers/url_launch_helper.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/images_and_links/main_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/second_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/startpoint_image_and_link_provider.dart';
import '../../providers/location_provider.dart';
import 'app_outdated.dart';

class EventInfoWeb extends ConsumerStatefulWidget {
  const EventInfoWeb({super.key});

  @override
  ConsumerState<EventInfoWeb> createState() => _EventInfoWebState();
}

class _EventInfoWebState extends ConsumerState<EventInfoWeb>
    with WidgetsBindingObserver {
  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initEventUpdates();
      context.read(activeEventProvider.notifier).refresh(forceUpdate: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read(activeEventProvider.notifier).refresh(forceUpdate: true);
      context.read(locationProvider).refresh(forceUpdate: true);
    }
  }

  void initEventUpdates() async {
    // first start
    context.read(activeEventProvider.notifier).refresh();
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        if (!mounted) return;
        context.read(activeEventProvider.notifier).refresh();
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var nextEventProvider = context.watch(activeEventProvider);
    //var iheight = MediaQuery.of(context).size.height * .2;
    var iwidth = MediaQuery.of(context).size.width * .3;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const AppOutdatedWidget(),
        if (nextEventProvider.status == EventStatus.noevent)
          Text(Localize.of(context).noEventPlanned,
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.textStyle),
        if (nextEventProvider.status != EventStatus.noevent)
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FittedBox(
                child: Text(Localize.of(context).nextEvent,
                    textAlign: TextAlign.center,
                    style: CupertinoTheme.of(context).textTheme.textStyle),
              ),
              const SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.scaleDown,
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
              const SizedBox(height: 1),
            ],
          ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: iwidth,
                child: GestureDetector(
                  onTap: () {
                    if (ref.read(mainSponsorImageAndLinkProvider).link !=
                        null) {
                      Launch.launchUrlFromString(
                          ref.read(mainSponsorImageAndLinkProvider).link!);
                    }
                  },
                  child: Builder(builder: (context) {
                    var ms = ref.watch(mainSponsorImageAndLinkProvider);
                    //var nw = context.watch(networkAwareProvider);
                    return (ms.image != null)
                        // && nw.connectivityStatus == ConnectivityStatus.online)
                        ? FadeInImage.assetNetwork(
                            placeholder: mainSponsorPlaceholder,
                            image: ms.image!,
                            fadeOutDuration: const Duration(milliseconds: 150),
                            fadeInDuration: const Duration(milliseconds: 150),
                            imageErrorBuilder: (context, error, stackTrace) {
                              BnLog.error(
                                  text:
                                      'mainSponsorPlaceholder ${ms.image}) could not been loaded',
                                  exception: error);
                              return Image.asset(mainSponsorPlaceholder,
                                  fit: BoxFit.fitWidth);
                            },
                          )
                        : const Image(
                            image: AssetImage(mainSponsorPlaceholder),
                          );
                  }),
                ),
              ),
              SizedBox(
                width: iwidth,
                child: GestureDetector(
                  onTap: () {
                    if (context.read(secondSponsorImageAndLinkProvider).link !=
                        null) {
                      Launch.launchUrlFromString(context
                          .read(secondSponsorImageAndLinkProvider)
                          .link!);
                    }
                  },
                  child: Builder(builder: (context) {
                    var ssp = context.watch(secondSponsorImageAndLinkProvider);
                    return ssp.image != null
                        ? FadeInImage.assetNetwork(
                            placeholder: secondLogoPlaceholder,
                            image: ssp.image!,
                            fadeOutDuration: const Duration(milliseconds: 150),
                            fadeInDuration: const Duration(milliseconds: 150),
                            imageErrorBuilder: (context, error, stackTrace) {
                              if (!kIsWeb) {
                                BnLog.error(
                                    text:
                                        'secondSponsorPlaceholder ${ssp.image} could not been loaded',
                                    exception: error);
                              }
                              return Image.asset(secondLogoPlaceholder,
                                  fit: BoxFit.fitWidth);
                            },
                          )
                        : Image.asset(secondLogoPlaceholder,
                            fit: BoxFit.fitWidth);
                  }),
                ),
              ),
            ]),
        if (nextEventProvider.status != EventStatus.noevent)
          GestureDetector(
            onTap: () async {
              ProviderContainer().refresh(activeEventProvider);
            },
            child: Column(
              children: [
                //Don't show starting point when no event
                if (nextEventProvider.status != EventStatus.noevent)
                  Builder(builder: (context) {
                    var spp = ref.watch(startpointImageAndLinkProvider);
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
    );
  }
}
