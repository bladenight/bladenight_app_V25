import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/refresh_timer_provider.dart';

class UpdateProgress extends ConsumerWidget {
  const UpdateProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Stack(alignment: Alignment.center, children: [
        Icon(
            size: 18.0,
            CupertinoIcons.info_circle_fill,
            color: CupertinoTheme.of(context).primaryColor),
        CircularProgressIndicator(
          backgroundColor:
              CupertinoTheme.of(context).primaryColor.withAlpha(100),
          color: CupertinoTheme.of(context).primaryColor,
          value: ref.watch(percentLeftProvider),
          strokeWidth: 3,
        ),
      ]),
    );
  }
}
