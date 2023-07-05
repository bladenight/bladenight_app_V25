import 'package:flutter/cupertino.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';

Widget settingsInvisibleOfflineWidget(BuildContext context) {
  var pr =
      context.watch(networkAwareProvider);
  if (pr.connectivityStatus==ConnectivityStatus.online) {
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
