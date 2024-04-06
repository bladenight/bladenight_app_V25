import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/location_provider.dart';
import '../../../providers/map/icon_size_provider.dart';
import '../../../providers/settings/me_color_provider.dart';

/// The default [Widget] that shows the device's position. By default, it is a
/// blue circle with a white border. The color can be changed and a child can be
/// displayed inside the circle.
class UserLocationMarker extends ConsumerWidget {
  /// Typically the marker's icon. Default to null.

  /// Create a DefaultLocationMarker.
  const UserLocationMarker({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var iconSize = ref.watch(iconSizeProvider);
    return CircleAvatar(
      radius: MediaQuery.textScalerOf(context).scale(iconSize),
      backgroundColor: CupertinoTheme.of(context).primaryColor,
      child: CircleAvatar(
        backgroundColor: CupertinoTheme.of(context).primaryColor,
        child: ref.watch(isUserParticipatingProvider)
            ? ImageIcon(
                size: MediaQuery.textScalerOf(context).scale(iconSize) - 10,
                const AssetImage('assets/images/skater_icon_256_bearer.png'),
                color: ref.watch(meColorProvider),
              )
            : Icon(
                Icons.compass_calibration_rounded,
                color: ref.watch(meColorProvider),
              ),
      ),
    );
  }
}
