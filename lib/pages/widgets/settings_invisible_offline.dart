import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';

class SettingsInvisibleOfflineWidget extends ConsumerWidget {
  const SettingsInvisibleOfflineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pr = ref.watch(networkAwareProvider);
    if (pr.connectivityStatus == ConnectivityStatus.wampNotConnected) {
      return Container();
    } else {
      return Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.systemRed,
        ),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                Localize.of(context).someSettingsNotAvailableBecauseOffline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      );
    }
  }
}
