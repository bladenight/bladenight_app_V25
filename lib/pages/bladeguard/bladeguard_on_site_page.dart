import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/rest_api/bladeguard_rest_api.dart';
import '../../models/event.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/network_connection_provider.dart';
import '../../providers/settings/bladeguard_provider.dart';

class BladeGuardOnsite extends ConsumerWidget {
  BladeGuardOnsite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bladeguardSettingsVisible =
        ref.watch(bladeguardSettingsVisibleProvider);
    var activeEvent =
        ref.watch(activeEventProvider.select((value) => value.status));
    var networkConnected = context.watch(
        networkAwareProvider.select((value) => value.connectivityStatus));
    return ((activeEvent == EventStatus.confirmed ||
                activeEvent == EventStatus.running) &&
            networkConnected == ConnectivityStatus.online &&
            bladeguardSettingsVisible)
        ? Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CupertinoButton(
                  onPressed: () {
                    checkBladeguardOnSite(
                        true, HiveSettingsDB.bladeguardSHA512Hash);
                  },
                  color: Colors.lightGreen,
                  child: const Text('Ich bin heute als Bladeguard vor Ort'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CupertinoButton(
                  onPressed: () {
                    checkBladeguardOnSite(
                        true, HiveSettingsDB.bladeguardSHA512Hash);
                  },
                  color: Colors.orange,
                  child: const Text(
                      'Ich kann heute leider nicht als Bladeguard teilnehmen'),
                ),
              ),
            ],
          )
        : Container();
  }
}
