import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';
import '../../../models/event.dart';

class EventStatusPicker extends ConsumerStatefulWidget {
  const EventStatusPicker({super.key});

  @override
  ConsumerState<EventStatusPicker> createState() => _EventStatusPickerState();

  Future<EventStatus?> showStatusDialog(BuildContext context,
      {EventStatus? current}) {
    EventStatus? status;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(Localize.of(context).setState),
          content: SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: current?.index ?? 0),
              onSelectedItemChanged: (int value) {
                status = EventStatus.values[value];
              },
              itemExtent: 50,
              children: [
                for (var status in EventStatus.values)
                  Center(
                    child: Text(
                        '${Localize.of(context).status}: ${Intl.select(status, {
                          EventStatus.pending: Localize.of(context).pending,
                          EventStatus.confirmed: Localize.of(context).confirmed,
                          EventStatus.cancelled: Localize.of(context).canceled,
                          EventStatus.noevent: Localize.of(context).noEvent,
                          EventStatus.running: Localize.of(context).running,
                          EventStatus.finished: Localize.of(context).finished,
                          EventStatus.deleted: Localize.of(context).delete,
                          'other': Localize.of(context).unknown
                        })}'),
                  ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                if (context.canPop()) {
                  context.pop(status);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _EventStatusPickerState extends ConsumerState<EventStatusPicker> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
