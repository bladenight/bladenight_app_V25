import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/enums/tracking_type.dart';
import '../buttons/tinted_cupertino_button.dart';
import '../sheets/grip_bar.dart';

class TrackingTypeWidget extends ConsumerWidget {
  const TrackingTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoScrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          const GripBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                CupertinoFormSection(
                  header: Text(Localize.of(context).startParticipation),
                  children: [
                    SizedTintedCupertinoButton(
                        child: Row(children: [
                          const Icon(CupertinoIcons.play_arrow_solid),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(Localize.of(context)
                                .startParticipationTracking),
                          ),
                        ]),
                        onPressed: () => Navigator.of(context)
                            .pop(TrackingType.userParticipating)),
                  ],
                ),
                CupertinoFormSection(
                  header: Text(Localize.of(context)
                      .startLocationWithoutParticipatingInfo),
                  children: [
                    SizedTintedCupertinoButton(
                        color: CupertinoTheme.of(context).primaryColor,
                        child: Row(children: [
                          const Icon(CupertinoIcons.play_arrow_solid),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(Localize.of(context)
                                .startLocationWithoutParticipating),
                          ),
                        ]),
                        onPressed: () =>
                            context.pop(TrackingType.userNotParticipating)),
                  ],
                ),
                CupertinoFormSection(
                  header: Text(Localize.of(context).startTrackingOnlyTitle),
                  children: [
                    SizedTintedCupertinoButton(
                        color: CupertinoTheme.of(context).primaryColor,
                        child: Row(children: [
                          const Icon(CupertinoIcons.play_arrow_solid),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(Localize.of(context).startTrackingOnly),
                          ),
                        ]),
                        onPressed: () => Navigator.of(context)
                            .pop(TrackingType.onlyTracking)),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
