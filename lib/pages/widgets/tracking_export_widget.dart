import 'dart:async';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../providers/location_provider.dart';
import 'string_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../providers/map/map_settings_provider.dart';
import 'user_tracking_dialog.dart';

class TrackingExportWidget extends ConsumerStatefulWidget {
  const TrackingExportWidget({super.key});

  @override
  ConsumerState<TrackingExportWidget> createState() => _TrackingExportState();
}

class _TrackingExportState extends ConsumerState<TrackingExportWidget> {
  String dateString = '';
  var trackedDates = <String>[];
  var _selectedItem = 0;

  void _onSelectedItemChanged(int value) {
    setState(() => dateString = trackedDates[value]);
    _selectedItem = value;
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(showOwnTrackProvider)) {
      return Container();
    }
    _updateDates();
    bool exportTrackingInProgress = false;
    return CupertinoFormSection(
        header: Text(Localize.of(context).exportUserTrackingHeader),
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: CupertinoButton(
                  child: Text(dateString),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => StringPicker(
                        title: Localize.of(context).selectDate,
                        items: LocationStore.getTrackDates(),
                        selectedItem: trackedDates.indexOf(dateString),
                        onSelectedItemChanged: _onSelectedItemChanged,
                      ),
                    );
                  }),
            ),
            CupertinoButton(
                child: exportTrackingInProgress
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.map_rounded),
                onPressed: () async {
                  if (exportTrackingInProgress) return;
                  var tp = LocationStore.getUserTrackPointsListByDate(
                      DateFormatter.fromString(dateString));
                  UserTrackDialog.show(context, tp, dateString);
                }),
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
                await LocationProvider.instance.saveLocationToDB();
                await compute(
                        exportUserTrackingToXml,
                        LocationStore.getUserGpxPointsListByDate(
                            DateFormatter.fromString(dateString)))
                    .then((value) =>
                        shareExportedTrackingData(value, dateString));
                setState(() {
                  exportTrackingInProgress = false;
                });
              }),
          if (!HiveSettingsDB.useAlternativeLocationProvider) ...[
            CupertinoFormSection(
                header: Text(Localize.of(context).resetOdoMeter),
                children: <Widget>[
                  CupertinoButton(
                    child: Text(Localize.of(context).resetOdoMeterTitle),
                    onPressed: () async {
                      await LocationProvider.instance.resetOdoMeter(context);
                      setState(() {});
                    },
                  ),
                ]),
            CupertinoFormSection(
                header: Text(Localize.of(context).resetTrackPointsStoreTitle),
                children: <Widget>[
                  CupertinoButton(
                    child: Text(Localize.of(context).resetTrackPointsStore),
                    onPressed: () async {
                      await clearAllTrackPoints();
                      setState(() {});
                    },
                  ),
                ]),
          ],
        ]);
  }

  Future clearAllTrackPoints() async {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        showCancelBtn: true,
        title: Localize.current.resetTrackPointsStoreTitle,
        text: Localize.current.resetTrackPointsStore,
        confirmBtnText: Localize.current.yes,
        cancelBtnText: Localize.current.cancel,
        onConfirmBtnTap: () {
          LocationStore.clearTrackPointStore();
          dateString = '';
          _updateDates();
          setState(() {});
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
  }

  void _updateDates() {
    trackedDates = LocationStore.getTrackDates();
    if (dateString.isEmpty || dateString.length==1){
      dateString = trackedDates.last;
    _selectedItem=trackedDates.indexOf(dateString);
    }
  }
}
