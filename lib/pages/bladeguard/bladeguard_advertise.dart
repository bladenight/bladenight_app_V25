import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/settings/bladeguard_provider.dart';
import 'bladeguard_page.dart';

class BladeGuardAdvertise extends ConsumerWidget {
  const BladeGuardAdvertise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isBladeGuard = ref.watch(userIsBladeguardProvider);
    if (!isBladeGuard) {
      return SizedBox(
        height: 20,
        child: FloatingActionButton.extended(
          foregroundColor: CupertinoTheme.of(context).primaryColor,
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          heroTag: 'isBladeGuardTag',
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const BladeGuardPage(),
              ),
            );
          },
          label: Text(Localize.of(context).becomeBladeguard),
          icon: Container(),
        ),
        //const ServerNotReachableWarning(),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const BladeGuardPage(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/bladeguard_smile.jpg'),
            ),
          ),
        ],
      );
    }
  }
}
