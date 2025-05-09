import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/network_connection_provider.dart';
import 'alert_animated_widget.dart';

class SettingsInvisibleOfflineWidget extends ConsumerWidget {
  const SettingsInvisibleOfflineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var connectionStatus = ref.watch(networkAwareProvider).connectivityStatus;
    if (connectionStatus == ConnectivityStatus.internetOffline) {
      return AlertAnimated(
        child: Text(
          Localize.of(context).someSettingsNotAvailableBecauseOffline,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container();
    }
  }
}
