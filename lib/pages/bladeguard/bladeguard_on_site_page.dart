import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:riverpod_context/riverpod_context.dart';

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
    var nextEventProvider = context.watch(activeEventProvider);
    var diff =
        DateTime.now().toUtc().difference(nextEventProvider.startDateUtc);
    var canRegisterOnSite = false;
    if (diff < const Duration(hours: 3) && diff < const Duration(seconds: 0)) {
      canRegisterOnSite = true;
    }
    var eventActive =
        ref.watch(realtimeDataProvider.select((rt) => rt?.eventIsActive)) ??
            false;
    final isOnSiteAsync = ref.watch(bgIsOnSiteProvider);
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    var networkConnected = context.watch(
        networkAwareProvider.select((value) => value.connectivityStatus));
    return isOnSiteAsync.when(error: (e, st) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: CupertinoButton(
          onPressed: () async {
            var _ = ref.refresh(bgIsOnSiteProvider);
          },
          color: Colors.redAccent,
          child: Text(Localize.of(context).networkerror),
        ),
      );
    }, loading: () {
      return const CircularProgressIndicator();
    }, data: (status) {
      return ((nextEventProvider.status == EventStatus.confirmed &&
                  !eventActive) &&
              canRegisterOnSite &&
              networkConnected == ConnectivityStatus.online &&
              bladeguardSettingsVisible)
          ? Column(
              children: [
                if (status == false) ...[
                  Text(Localize.of(context).bgTodayRegister),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CupertinoButton(
                      onPressed: () async {
                        ref
                            .read(bgIsOnSiteProvider.notifier)
                            .setOnSiteState(true);
                      },
                      color: Colors.lightGreen,
                      child: Text(Localize.of(context).bgTodayOnSite),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
                if (status == true) ...[
                  Text(Localize.of(context).bgTodayNotOnSite),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CupertinoButton(
                      onPressed: () async {
                        await ScrollQuickAlert.show(
                            context: context,
                            showCancelBtn: true,
                            type: QuickAlertType.confirm,
                            title: Localize.of(context).requestOffSiteTitle,
                            text: Localize.of(context).requestOffSite,
                            confirmBtnText: Localize.of(context).todayNo,
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
                      child: Text(Localize.of(context).bgTodayNotParticipation),
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
