import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../providers/app_outdated_provider.dart';

class AppOutdatedWidget extends ConsumerWidget {
  const AppOutdatedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pr = context.watch(appOutdatedProvider);
    if (!pr) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemRed,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  Localize.of(context).appOutDated,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        ),
      );
    }
  }
}
