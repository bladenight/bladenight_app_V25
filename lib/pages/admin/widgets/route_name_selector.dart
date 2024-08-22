import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/get_all_routes_provider.dart';
import '../../widgets/no_data_warning.dart';

class RouteNameSelector extends ConsumerStatefulWidget {
  const RouteNameSelector(
      {required this.currentRouteName, this.onChanged, super.key});

  final String currentRouteName;
  final ValueChanged<String>? onChanged;

  @override
  ConsumerState<RouteNameSelector> createState() => _RouteNameSelectorState();

  ///Opens a picker and returns the selected value onChanged
  static Future<String?> showRouteNameDialog(
      BuildContext context, String current, ValueChanged<String>? onChanged) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(Localize.of(context).setRoute),
            content: SizedBox(
              height: 100,
              child: RouteNameSelector(
                currentRouteName: current,
                onChanged: onChanged,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(Localize.of(context).ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class _RouteNameSelectorState extends ConsumerState<RouteNameSelector> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
            var routeName = routeNames.routeNames?.first;
            if (routeNames.routeNames == null) {
              return const Text('Keine Routen vorh.');
            }
            var currentIndex =
                routeNames.routeNames!.indexOf(widget.currentRouteName);
            if (currentIndex == -1) currentIndex = 0;
            return CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: currentIndex),
                onSelectedItemChanged: (int value) {
                  if (routeNames.routeNames != null) {
                    routeName = routeNames.routeNames![value];
                  }
                  if (widget.onChanged != null && routeName != null) {
                    widget.onChanged!(routeName!);
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
    });
  }
}
