import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/enums/tracking_type.dart';
import '../buttons/tinted_cupertino_button.dart';
import '../sheets/grip_bar.dart';

class TrackingTypeWidget extends ConsumerWidget {
  TrackingTypeWidget({super.key});

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          const GripBar(),
          Expanded(
            child: ListView(
              controller: _scrollController,
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
                        onPressed: () =>
                            context.pop(TrackingType.userParticipating)),
                  ],
                ),
                CupertinoFormSection(
                  header: Text(Localize.of(context)
                      .startLocationWithoutParticipatingInfo),
                  children: [
                    SizedTintedCupertinoButton(
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
                        child: Row(children: [
                          const Icon(CupertinoIcons.play_arrow_solid),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(Localize.of(context).startTrackingOnly),
                          ),
                        ]),
                        onPressed: () =>
                            context.pop(TrackingType.onlyTracking)),
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
