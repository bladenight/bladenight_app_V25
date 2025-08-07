import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class NoNetworkWarning extends ConsumerWidget {
  const NoNetworkWarning({super.key, this.reason});

  final Exception? reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber,
            color: Colors.redAccent,
            size: 44,
          ),
          Text(
            Localize.of(context).seemsoffline,
            style: CupertinoTheme.of(context)
                .textTheme
                .pickerTextStyle
                .copyWith(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          if (reason != null)
            Text(
              reason.toString(),
              style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
