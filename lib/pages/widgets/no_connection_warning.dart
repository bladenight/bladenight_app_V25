import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';

class ConnectionWarning extends ConsumerWidget {
  const ConnectionWarning({super.key, this.reason});

  final Exception? reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var networkAware = ref.watch(networkAwareProvider);
    if (networkAware.connectivityStatus == ConnectivityStatus.error ||
        networkAware.connectivityStatus == ConnectivityStatus.disconnected) {
      return SizedBox(
        height: 20,
        child: FloatingActionButton.extended(
          heroTag: 'wwwNotReachableTag',
          onPressed: () => ref.read(networkAwareProvider.notifier).refresh(),
          label: Text(Localize.of(context).seemsoffline),
          icon: const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
            ),
          ),
        ),
        //const ServerNotReachableWarning(),
      );
    } else if (networkAware.serverAvailable == false) {
      return SizedBox(
        height: 20,
        child: FloatingActionButton.extended(
          heroTag: 'serverNotReachableTag',
          onPressed: () => ref.read(networkAwareProvider.notifier).refresh(),
          label: Text(Localize.of(context).serverNotReachable),
          icon: const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
            ),
          ),
        ),
        //const ServerNotReachableWarning(),
      );
    } else {
      return Container();
    }
  }
}
