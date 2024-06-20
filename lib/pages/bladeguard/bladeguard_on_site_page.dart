import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../app_settings/app_constants.dart';
import '../../generated/l10n.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/realtime_data_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';
import '../widgets/scroll_quick_alert.dart';

class BladeGuardOnsite extends ConsumerWidget {
  const BladeGuardOnsite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    if (!bladeguardSettingsVisible) {
      return Container();
    }

    var nextEventProvider = context.watch(activeEventProvider);
    var diff = nextEventProvider.startDateUtc
        .difference(DateTime.now().toUtc())
        .inMinutes;
    var canRegisterOnSite = false;

    var eventActive =
        ref.watch(realtimeDataProvider.select((rt) => rt?.eventIsActive)) ??
            false;

    var minPreTime = defaultMinPreOnsiteLogin;
    if (diff < minPreTime && diff > 0 && !eventActive) {
      canRegisterOnSite = true;
    }
    final isOnSiteAsync = ref.watch(bgIsOnSiteProvider);
    var networkConnected = context.watch(
        networkAwareProvider.select((value) => value.connectivityStatus));
    return isOnSiteAsync.when(error: (e, st) {
      return Column(mainAxisSize: MainAxisSize.max, children: [
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
      ]);
    }, loading: () {
      return const CupertinoActivityIndicator();
    }, data: (status) {
      return ((nextEventProvider.status == EventStatus.confirmed &&
                  !eventActive) &&
              canRegisterOnSite &&
              networkConnected == ConnectivityStatus.online)
          ? Column(
              children: [
                if (status == false) ...[
                  Column(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          Text(
                            Localize.of(context).bgTodayRegister,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(10.0),
                              onPressed: () async {
                                ref
                                    .read(bgIsOnSiteProvider.notifier)
                                    .setOnSiteState(true);
                              },
                              color: Colors.green,
                              child: Text(
                                Localize.of(context).bgTodayOnSite,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
                ],
                if (status == true) ...[
                  Column(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          Text(
                            Localize.of(context).bgTodayNotOnSite,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(10.0),
                              onPressed: () async {
                                await ScrollQuickAlert.show(
                                    context: context,
                                    showCancelBtn: true,
                                    type: QuickAlertType.confirm,
                                    title: Localize.of(context)
                                        .requestOffSiteTitle,
                                    text: Localize.of(context).requestOffSite,
                                    confirmBtnText:
                                        Localize.of(context).todayNo,
                                    cancelBtnText: Localize.of(context).cancel,
                                    onConfirmBtnTap: () {
                                      ref
                                          .read(bgIsOnSiteProvider.notifier)
                                          .setOnSiteState(false);
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                    });
                              },
                              color: Colors.orange,
                              child: Text(
                                Localize.of(context).bgTodayNotParticipation,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ],
            )
          : (nextEventProvider.status == EventStatus.confirmed &&
                  !canRegisterOnSite &&
                  !eventActive)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(10.0),
                      onPressed: () async {},
                      color: Colors.yellow,
                      child: Text(
                        Localize.of(context).loginThreeHoursBefore,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Container();
    });
  }
}
