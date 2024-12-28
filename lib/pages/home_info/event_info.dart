import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/enums/tracking_type.dart';
import '../../helpers/logger.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/get_images_and_links_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../bladeguard/bladeguard_advertise.dart';
import '../bladeguard/bladeguard_on_site_page.dart';
import '../widgets/app_outdated.dart';
import '../widgets/no_connection_warning.dart';
import '../widgets/shadow_box_widget.dart';
import 'event_data_overview.dart';

class EventInfo extends ConsumerStatefulWidget {
  const EventInfo({super.key});

  @override
  ConsumerState<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends ConsumerState<EventInfo>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? _updateTimer;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initEventUpdates();
      initLocation();
      //call on first start
    });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _animationController.dispose();
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
    var nextEvent = ref.watch(activeEventProvider);
    return SafeArea(
      //height: 300,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ref.watch(networkAwareProvider).connectivityStatus !=
                ConnectivityStatus.wampConnected)
              ConnectionWarning(
                  shimmerAnimationController: _animationController),
            AppOutdated(animationController: _animationController),
            ShadowBoxWidget(
              boxShadowColor: nextEvent.statusColor,
              child: EventDataOverview(
                nextEvent: nextEvent,
              ),
            ),
            const BladeGuardAdvertise(),
            const BladeGuardOnsite(),
            const SizedBox(
              height: 5,
            ),
            /*GridView.count(
                primary: false,
                padding: const EdgeInsets.all(5),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                children: <Widget>[
                  SizedBox(
                    height: 100,
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
                        //var nw = ref.watch(networkAwareProvider);
                        return (ms.image != null)
                            // && nw.connectivityStatus == ConnectivityStatus.online)
                            ? FadeInImage.assetNetwork(
                                placeholder: mainSponsorPlaceholder,
                                image: ms.image!,
                                fadeOutDuration:
                                    const Duration(milliseconds: 150),
                                fadeInDuration:
                                    const Duration(milliseconds: 150),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
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
                    height: 100,
                    child: GestureDetector(
                      onTap: () {
                        if (ref.read(secondSponsorImageAndLinkProvider).link !=
                            null) {
                          Launch.launchUrlFromString(ref
                              .read(secondSponsorImageAndLinkProvider)
                              .link!);
                        }
                      },
                      child: Builder(builder: (context) {
                        var ssp = ref.watch(secondSponsorImageAndLinkProvider);
                        return ssp.image != null
                            ? FadeInImage.assetNetwork(
                                placeholder: secondLogoPlaceholder,
                                image: ssp.image!,
                                fadeOutDuration:
                                    const Duration(milliseconds: 150),
                                fadeInDuration:
                                    const Duration(milliseconds: 150),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
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
                ]),*/
          ],
        ),
      ),
    );
  }
}
