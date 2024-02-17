import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/follow_location_state.dart';

class AlignMapIcon extends StatelessWidget {
  const AlignMapIcon({required this.alignMapStatus, super.key});
  final AlignFlutterMapState alignMapStatus;
  @override
  Widget build(BuildContext context) {
    switch (alignMapStatus) {
      case AlignFlutterMapState.alignNever:
        return const ImageIcon(AssetImage('assets/images/no_navigation_256.png'));
      case AlignFlutterMapState.alignDirectionOnUpdateOnly:
        return const ImageIcon(AssetImage('assets/images/navigate_north.png'));
      case AlignFlutterMapState.alignPositionOnUpdateOnly:
        return const ImageIcon(AssetImage('assets/images/navigate_right_arrow_256.png'));
      case AlignFlutterMapState.alignDirectionAndPositionOnUpdate:
        return const ImageIcon(AssetImage('assets/images/navigate_right_circle_256.png'));
    }
  }
}
