import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../generated/l10n.dart';
import '../../providers/app_start_and_router/go_router.dart';
import '../../providers/settings/bladeguard_provider.dart';
import '../widgets/common_widgets/shadow_box_widget.dart';

class BladeGuardAdvertise extends ConsumerWidget {
  const BladeGuardAdvertise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isBladeGuard = ref.watch(userIsBladeguardProvider);
    if (!isBladeGuard) {
      return ShadowBoxWidget(
        child: SizedBox(
          height: 20,
          width: double.infinity,
          child: FloatingActionButton.extended(
            foregroundColor: CupertinoTheme.of(context).primaryColor,
            backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
            heroTag: 'isBladeGuardTag',
            onPressed: () {
              context.pushNamed(AppRoute.bladeguard.name);
            },
            label: Text(Localize.of(context).becomeBladeguard),
            icon: Container(),
          ),
          //const ServerNotReachableWarning(),
        ),
      );
    } else {
      return Container();
    }
  }
}
