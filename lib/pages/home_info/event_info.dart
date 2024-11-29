import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/cupertino.dart';
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
import '../../providers/map/icon_size_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../bladeguard/bladeguard_advertise.dart';
import '../bladeguard/bladeguard_on_site_page.dart';
import '../widgets/app_outdated.dart';
import '../widgets/event_info/animation_test_widget.dart';
import '../widgets/hidden_admin_button.dart';
import '../widgets/no_connection_warning.dart';
import '../widgets/current_event_overview.dart';
import '../widgets/shadow_box_widget.dart';
import '../widgets/title_widget.dart';
import 'event_data_overview.dart';
import 'event_map_small.dart';
import 'logo_animate.dart';

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
            const ConnectionWarning(),
            const AppOutdated(),
            ShadowBoxWidget(
              boxShadowColor: nextEvent.statusColor,
              child: EventDataOverview(
                nextEvent: nextEvent,
                parentAnimationController: _animationController,
              ),
            ),
            const BladeGuardAdvertise(),
            const BladeGuardOnsite(),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
