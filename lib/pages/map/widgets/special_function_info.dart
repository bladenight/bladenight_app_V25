import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/is_tracking_provider.dart';
import '../../../providers/special_procession_function_provider.dart';

class SpecialFunctionInfo extends ConsumerWidget {
  const SpecialFunctionInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isTracking = ref.watch(isTrackingProvider);
    var isProcessionHead = ref.watch(isProcessionHeadProvider);
    var isProcessionTail = ref.watch(isProcessionTailProvider);
    var wantSeeFullProcession = ref.watch(wantSeeFullProcessionProvider);

    return Column(children: [
      if (isTracking && isProcessionHead)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: ([
            Expanded(
              child: SizedBox(
                height: MediaQuery.textScalerOf(context).scale(25),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: ColoredBox(
                    color: Color(0xFFFFD700),
                    child: FittedBox(
                      child: Text(
                        Localize.of(context).head,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      if (isTracking && isProcessionTail)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: ([
            Expanded(
              child: SizedBox(
                height: MediaQuery.textScalerOf(context).scale(25),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: ColoredBox(
                    color: Colors.redAccent,
                    child: FittedBox(
                      child: Text(
                        Localize.of(context).tail,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      /*if (!kIsWeb &&
          (ref.watch(showOwnColoredTrackProvider) ||
              (isTracking && wantSeeFullProcession))) ...[
        const SpeedInfoColors(),
      ],*/
    ]);
  }
}
