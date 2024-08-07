import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../providers/map/map_settings_provider.dart';

class TrackingExportWidget extends ConsumerStatefulWidget {
  const TrackingExportWidget({super.key});

  @override
  ConsumerState<TrackingExportWidget> createState() =>
      _TrackingExportState();
}

class _TrackingExportState extends ConsumerState<TrackingExportWidget> {
  @override
  Widget build(BuildContext context) {
    if (!ref.watch(showOwnTrackProvider)) {
      return Container();
    }
    return CupertinoFormSection(
        header: Text(Localize.of(context).exportUserTrackingHeader),
        children: <Widget>[
          Builder(
            builder: (context) {
              var trackedDates = LocationStore.getTrackDates();
              var dateString = trackedDates.last;
              bool exportTrackingInProgress = false;
              return CupertinoFormSection(
                  header: Text(Localize.of(context).exportUserTrackingHeader),
                  children: <Widget>[
                    CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        onSelectedItemChanged: (int value) {
                          dateString = trackedDates[value];
                        },
                        itemExtent: 50,
                        children: [
                          for (var i in trackedDates)
                            Center(child: Text(i.toString()))
                        ]),
                    CupertinoButton(
                        child: exportTrackingInProgress
                            ? const CircularProgressIndicator()
                            : Text(Localize.of(context).exportUserTracking),
                        onPressed: () async {
                          if (exportTrackingInProgress) return;
                          setState(() {
                            exportTrackingInProgress = true;
                          });
                          await compute(
                                  exportUserTracking,
                                  LocationStore.getUserTrackPointsListByDate(
                                      DateFormatter.fromString(dateString)))
                              .then(
                                  (value) => shareExportedTrackingData(value));
                          exportTrackingInProgress = false;

                          setState(() {});
                        }),
                  ]);
            },
          ),
        ]);
  }
}
