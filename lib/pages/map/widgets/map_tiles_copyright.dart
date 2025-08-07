import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../providers/active_event_provider.dart';
import 'bayern_atlas_copyright.dart';
import 'open_street_map_copyright.dart';

class MapTilesCopyright extends ConsumerWidget {
  const MapTilesCopyright({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapSettings.openStreetMapEnabled ||
            ref.watch(activeEventProvider).hasSpecialStartPoint
        ? OpenStreetMapCopyright()
        : BayernAtlasCopyright();
  }
}
