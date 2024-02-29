import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';
import 'no_network_warning.dart';
import 'no_server_reachable_warning.dart';

class NoDataWarning extends ConsumerWidget {
  const NoDataWarning({super.key, required this.onReload});

  final VoidCallback onReload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(builder: (context) {
            var networkAware = ref.watch(networkAwareProvider);
            if (networkAware.connectivityStatus == ConnectivityStatus.error ||
                networkAware.connectivityStatus == ConnectivityStatus.disconnected) {
              return const NoNetworkWarning();
            } else if (networkAware.connectivityStatus ==
                ConnectivityStatus.serverNotReachable) {
              return const ServerNotReachableWarning();
            } else {
              return Container();
            }
          }),
          const Icon(
            Icons.warning_amber,
            color: Colors.redAccent,
            size: 44,
          ),
          Text(
            Localize.of(context).nodatareceived,
            style: CupertinoTheme.of(context)
                .textTheme
                .pickerTextStyle
                .copyWith(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: onReload,
            child: Text(
              Localize.of(context).reload,
              style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
