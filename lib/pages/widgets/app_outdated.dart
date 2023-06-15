import 'package:flutter/cupertino.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../providers/active_event_notifier_provider.dart';

Widget appOutdatedWidget(BuildContext context) {
  var pr =
      context.watch(activeEventProvider.select((value) => value.appIsOutdated));
  if (!pr) {
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
              Localize.of(context).appOutDated,
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
