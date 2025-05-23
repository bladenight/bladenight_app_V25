import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../models/event.dart';
import '../../../providers/location_provider.dart';

class OnsiteCounter extends ConsumerStatefulWidget {
  const OnsiteCounter({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  ConsumerState<OnsiteCounter> createState() => _OnsiteCounterState();
}

class _OnsiteCounterState extends ConsumerState<OnsiteCounter> {
  @override
  Widget build(BuildContext context) {
    var rtData = ref.watch(realtimeDataProvider);
    if (rtData != null &&
        rtData.bladeguardApiText != null &&
        rtData.bladeguardApiText != '') {
      return Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 0,
          bottom: 0,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            Localize.of(context).onsiteCount,
            textAlign: TextAlign.left,
          ),
          Text(
            rtData.bladeguardApiText ?? '-',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ]),
      );
    } else {
      return SizedBox();
    }
  }
}
