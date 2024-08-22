import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/get_all_routes_provider.dart';
import '../../widgets/no_data_warning.dart';

class EventRouteSelector extends ConsumerStatefulWidget {
  const EventRouteSelector({required this.routeName, super.key});

  final String routeName;

  @override
  ConsumerState<EventRouteSelector> createState() => _EventRouteSelectorState();
}

class _EventRouteSelectorState extends ConsumerState<EventRouteSelector> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
        child: Text(widget.routeName),
        onPressed: () async {
          var res =
              await showUserTrackDialog(context, current: widget.routeName);
          if (!context.mounted) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context, res);
          }
        });
  }

  Future<String?> showUserTrackDialog(BuildContext context, {String? current}) {
    String? route;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(Localize.of(context).setRoute),
          content: SizedBox(
            height: 100,
            child: Builder(builder: (context) {
              //ref not working here in Alert
              var routeNames = ref.watch(getAllRouteNamesProvider);
              return routeNames.maybeWhen(
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                  data: (routeNames) {
                    if (routeNames.exception != null) {
                      return NoDataWarning(
                        onReload: () => ref.read(getAllRouteNamesProvider),
                      );
                    }
                    route = routeNames.routeNames?.first;
                    return CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        onSelectedItemChanged: (int value) {
                          if (routeNames.routeNames != null) {
                            route = routeNames.routeNames![value];
                          }
                        },
                        itemExtent: 50,
                        children: [
                          if (routeNames.routeNames != null)
                            for (var i in routeNames.routeNames!)
                              Center(child: Text(i.toString()))
                        ]);
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  orElse: () {
                    return NoDataWarning(
                      onReload: () => ref.refresh(getAllRouteNamesProvider),
                    );
                  });
            }),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(route);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
