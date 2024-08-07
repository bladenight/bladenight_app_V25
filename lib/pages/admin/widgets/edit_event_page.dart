import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/event.dart';
import '../../../providers/get_all_routes_provider.dart';
import '../../widgets/no_data_warning.dart';

class EditEventPage extends ConsumerStatefulWidget {
  const EditEventPage({required this.event, super.key});

  final Event event;

  @override
  ConsumerState<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  String? routeName = '';

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
            routeName = routeNames.routeNames?.first;
            return CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: 0),
                onSelectedItemChanged: (int value) {
                  if (routeNames.routeNames != null) {
                    routeName = routeNames.routeNames![value];
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
