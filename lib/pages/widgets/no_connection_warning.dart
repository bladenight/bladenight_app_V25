import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/network_connection_provider.dart';
import 'no_network_warning.dart';
import 'no_server_reachable_warning.dart';

class ConnectionWarning extends ConsumerWidget {
  const ConnectionWarning({super.key, this.reason});

  final Exception? reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var networkAware = ref.watch(networkAwareProvider);
    if (networkAware.connectivityStatus == ConnectivityStatus.error ||
        networkAware.connectivityStatus == ConnectivityStatus.offline) {
      return GestureDetector(
        onTap: (() {
          var _ = ref.refresh(networkAwareProvider);
        }),
        child: const NoNetworkWarning(),
      );
    } else if (networkAware.connectivityStatus ==
        ConnectivityStatus.serverNotReachable) {
      return GestureDetector(
        onTap: (() {
          ProviderContainer().refresh(networkAwareProvider);
        }),
        child: const ServerNotReachableWarning(),
      );
    } else {
      return Container();
    }
  }
}
