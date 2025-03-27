import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_settings/app_constants.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';
import 'widgets/is_onsite_error.dart';
import 'widgets/is_onsite_not_registered.dart';
import 'widgets/is_onsite_registered.dart';
import 'widgets/wait_3_hours.dart';

class BladeGuardOnsite extends ConsumerStatefulWidget {
  const BladeGuardOnsite(
      {super.key, this.animationController, this.borderRadius = 15});

  final double borderRadius;
  final AnimationController? animationController;

  @override
  ConsumerState<BladeGuardOnsite> createState() => _BladeGuardOnsiteState();
}

class _BladeGuardOnsiteState extends ConsumerState<BladeGuardOnsite>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    if (widget.animationController != null) {
      _animationController = widget.animationController;
    } else {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );
    }
    _animationController!.repeat(reverse: true);
  }

  @override
  dispose() {
    if (widget.animationController == null) {
      _animationController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    if (!bladeguardSettingsVisible) {
      return Container();
    }

    var nextEvent = ref.watch(activeEventProvider);
    var diff =
        nextEvent.startDateUtc.difference(DateTime.now().toUtc()).inMinutes;
    var canRegisterOnSite = false;

    var eventActive = ref.watch(isActiveEventProvider);

    var minPreTime = defaultMinPreOnsiteLogin;
    if (diff < minPreTime && diff > 0 && !eventActive) {
      canRegisterOnSite = true;
    }
    final isOnSiteAsync = ref.watch(bgIsOnSiteProvider);
    var networkConnected = ref.watch(networkAwareProvider);
    return isOnSiteAsync.when(error: (e, st) {
      return IsOnsiteError(error: e.toString());
      /*Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 1, 15.0, 1),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(10.0),
                    onPressed: () async {
                      var _ = ref.refresh(bgIsOnSiteProvider);
                    },
                    color: Colors.redAccent,
                    child: e == ''
                        ? Text(
                            Localize.of(context).networkerror,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                  ),
                )
              ]),
            ))
      ]);*/
    }, loading: () {
      return const CupertinoActivityIndicator();
    }, data: (status) {
      return ((nextEvent.status == EventStatus.confirmed && !eventActive) &&
              canRegisterOnSite &&
              networkConnected.connectivityStatus !=
                  ConnectivityStatus.internetOffline)
          ? Column(
              children: [
                /*if (localTesting) ...[
                  Wait3Hours(
                    animationController: widget.animationController,
                  ),
                  IsOnsiteNotRegistered(
                    animationController: widget.animationController,
                  ),
                  IsOnsiteRegistered(
                    animationController: widget.animationController,
                  ),
                  IsOnsiteError(
                    error: 'Fehler',
                    animationController: widget.animationController,
                  ),
                ],*/

                if (status == false) IsOnsiteNotRegistered(),
                if (status == true) IsOnsiteRegistered(),
              ],
            )
          : (nextEvent.status == EventStatus.confirmed &&
                  !canRegisterOnSite &&
                  !eventActive)
              ? Wait3Hours(
                  event: nextEvent,
                  animationController: widget.animationController,
                )
              : Container();
    });
  }
}
