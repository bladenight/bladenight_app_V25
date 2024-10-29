import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/enums/tracking_type.dart';
import '../../helpers/logger.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../helpers/url_launch_helper.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/images_and_links/main_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/second_sponsor_image_and_link_provider.dart';
import '../../providers/images_and_links/startpoint_image_and_link_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../bladeguard/bladeguard_advertise.dart';
import '../bladeguard/bladeguard_on_site_page.dart';
import '../widgets/app_outdated.dart';
import '../widgets/hidden_admin_button.dart';
import '../widgets/no_connection_warning.dart';
import '../widgets/rounded_card.dart';
import '../widgets/title_widget.dart';
import 'logo_animate.dart';

class EventInfo extends ConsumerStatefulWidget {
  const EventInfo({super.key});

  @override
  ConsumerState<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends ConsumerState<EventInfo>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? _updateTimer;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
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
    _updateTimer?.cancel();
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BnLog.debug(text: 'event_info - didChangeAppLifecycleState $state');
    if (state == AppLifecycleState.resumed) {
      initEventUpdates(forceUpdate: true);
      ref.read(locationProvider).refreshRealtimeData(forceUpdate: true);
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _updateTimer?.cancel();
    }
  }

  void initEventUpdates({forceUpdate = false}) async {
    // first start
    ref.invalidate(updateImagesAndLinksProvider);
    await Future.delayed(const Duration(seconds: 2));
    await ref
        .read(activeEventProvider.notifier)
        .refresh(forceUpdate: forceUpdate);
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        if (LocationProvider().trackingType == TrackingType.onlyTracking) {
          return;
        }
        ref.read(activeEventProvider.notifier).refresh();
      },
    );
  }

  void initLocation() async {
    await Future.delayed(const Duration(seconds: 5));
    LocationProvider().refreshRealtimeData(forceUpdate: true);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var nextEventProvider = ref.watch(activeEventProvider);
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ConnectionWarning(),
            const AppOutdatedWidget(),
            const BladeGuardAdvertise(),
            const BladeGuardOnsite(),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: IntrinsicWidth(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HiddenAdminButton(
                        child: nextEventProvider.status == EventStatus.noevent
                            ? Text(Localize.of(context).noEventPlanned,
                                textAlign: TextAlign.center,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle)
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(Localize.of(context).nextEvent,
                                      textAlign: TextAlign.center,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 5, 15, 5),
                                    child: FittedBox(
                                      child: Text(
                                          DateFormatter(Localize.of(context))
                                              .getLocalDayDateTimeRepresentation(
                                                  nextEventProvider
                                                      .getUtcIso8601DateTime),
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navLargeTitleTextStyle),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: nextEventProvider.status ==
                                              EventStatus.cancelled
                                          ? Colors.redAccent
                                          : nextEventProvider.status ==
                                                  EventStatus.confirmed
                                              ? Colors.green
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(nextEventProvider.statusText,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .pickerTextStyle),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      ResponsiveRowColumn(
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        columnCrossAxisAlignment: CrossAxisAlignment.center,
                        columnMainAxisSize: MainAxisSize.min,
                        rowPadding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 80),
                        columnPadding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 50),
                        columnSpacing: 5,
                        rowSpacing: 5,
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(TABLET)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        children: [
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                var link = ref
                                    .read(mainSponsorImageAndLinkProvider)
                                    .link;
                                if (link != null && link != '') {
                                  var uri = Uri.parse(ref
                                      .read(mainSponsorImageAndLinkProvider)
                                      .link!);
                                  Launch.launchUrlFromUri(uri);
                                }
                              },
                              child: Builder(builder: (context) {
                                var ms =
                                    ref.watch(mainSponsorImageAndLinkProvider);
                                var nw = ref.watch(networkAwareProvider);
                                return (ms.image != null &&
                                        nw.connectivityStatus ==
                                            ConnectivityStatus.online)
                                    ? CachedNetworkImage(
                                        imageUrl: ms.image!,
                                        placeholder: (context, url) =>
                                            Image.asset(mainSponsorPlaceholder,
                                                fit: BoxFit.fitWidth),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(mainSponsorPlaceholder,
                                                fit: BoxFit.fitWidth),
                                        errorListener: (e) {
                                          BnLog.warning(
                                              text:
                                                  'Could not load ${ms.image}');
                                        },
                                      )
                                    : Image.asset(mainSponsorPlaceholder,
                                        fit: BoxFit.fitWidth);
                              }),
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: LogoAnimate(animationController),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            GestureDetector(
              onTap: () async {
                return;
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
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
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
            /*TitleView(
              titleTxt: 'Mediterranean diet',
              subTxt: 'Details',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: animationController,
            ),*/
            /*RoundedCard(
              animationController: animationController,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );

    /* return NoDataWarning(
        onReload: () => ref.read(activeEventProvider).refresh(),
      );*/
  }
}
