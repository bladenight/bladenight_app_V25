import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';
import 'no_connection_warning.dart';

class DataLoadingIndicator extends ConsumerWidget {
  const DataLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          Localize.of(context).getwebdata,
          style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
        ),
        if (ref.watch(networkAwareProvider).connectivityStatus !=
            ConnectivityStatus.wampConnected)
          ConnectionWarning(),
      ],
    );
  }
}
