import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/rest_api/onsite_state_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';

class BladeGuardOnsite extends ConsumerWidget {
  const BladeGuardOnsite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnSiteAsync = ref
        .watch(fetchOnSiteStateProvider(HiveSettingsDB.bladeguardSHA512Hash));
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    var activeEvent =
        ref.watch(activeEventProvider.select((value) => value.status));
    var networkConnected = context.watch(
        networkAwareProvider.select((value) => value.connectivityStatus));
    return isOnSiteAsync.when(
        error: (e, st) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
        data: (status) {
          return ((activeEvent == EventStatus.confirmed ||
                      activeEvent == EventStatus.running) &&
                  networkConnected == ConnectivityStatus.online &&
                  bladeguardSettingsVisible &&
                  status.errorDescription == null)
              ? Column(
                  children: [
                    if (status.result != null && status.result == 'false') ...[
                      Text(Localize.of(context).bgTodayRegister),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CupertinoButton(
                          onPressed: () async {
                            var res = await ref.read(setOnSiteStateProvider(
                                    true, HiveSettingsDB.bladeguardSHA512Hash)
                                .future);
                            var _ = await ref.refresh(fetchOnSiteStateProvider(
                                    HiveSettingsDB.bladeguardSHA512Hash)
                                .future);
                          },
                          color: Colors.lightGreen,
                          child:  Text(Localize.of(context).bgTodayOnSite),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                    if (status.result != null && status.result == 'true') ...[
                      Text(Localize.of(context).bgTodayNotOnSite),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CupertinoButton(
                          onPressed: () async {
                            var offSiteReq =
                                await FlutterPlatformAlert.showCustomAlert(
                                    windowTitle: Localize.of(context)
                                        .requestOffSiteTitle,
                                    text: Localize.of(context).requestOffSite,
                                    iconStyle: IconStyle.exclamation,
                                    positiveButtonTitle:
                                        Localize.of(context).todayNo,
                                    negativeButtonTitle: Localize.of(context).cancel);
                            if (offSiteReq == CustomButton.negativeButton) {
                              //user denies request
                              return;
                            }
                            var res = await ref.read(setOnSiteStateProvider(
                                    false, HiveSettingsDB.bladeguardSHA512Hash)
                                .future);

                            var _ = await ref.refresh(fetchOnSiteStateProvider(
                                    HiveSettingsDB.bladeguardSHA512Hash)
                                .future);
                          },
                          color: Colors.orange,
                          child:  Text(Localize.of(context).bgTodayNotParticipation),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ],
                )
              : Container();
        });
  }
}
