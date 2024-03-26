import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/speed_to_color.dart';
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

    return Column(
      children: [
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
                      color: Colors.yellowAccent,
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
        if (isTracking && wantSeeFullProcession)
          Align(
            child: StepProgressIndicator(
              totalSteps: SpeedToColor.speedColors.length,
              direction: Axis.horizontal,
              currentStep: SpeedToColor.speedColors.length,
              size: 12,
              unselectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: SpeedToColor.speedColors,
              ),
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: SpeedToColor.speedColors,
              ),
            ),
          ),
      ],
    );
  }
}
