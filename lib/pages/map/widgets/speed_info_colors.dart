import 'package:flutter/cupertino.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../helpers/speed_to_color.dart';

class SpeedInfoColors extends StatelessWidget {
  const SpeedInfoColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '0 km/h',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '15 km/h',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '25 km/h',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '40 km/h',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
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
