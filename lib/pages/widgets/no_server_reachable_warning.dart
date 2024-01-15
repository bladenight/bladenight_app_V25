import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';

class ServerNotReachableWarning extends ConsumerWidget {
  const ServerNotReachableWarning({super.key, this.reason});

  final Exception? reason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.orange.shade100,
            size: 44,
          ),
          Text(
            Localize.of(context).serverNotReachable,
            style: CupertinoTheme.of(context)
                .textTheme
                .pickerTextStyle
                .copyWith(color: Colors.orange.shade100),
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
