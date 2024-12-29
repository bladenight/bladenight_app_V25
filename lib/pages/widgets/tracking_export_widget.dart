import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../helpers/logger.dart';
import '../../models/user_gpx_point.dart';
import '../../providers/location_provider.dart';
import 'common_widgets/tinted_cupertino_button.dart';
import 'string_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/export_import_data_helper.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/time_converter_helper.dart';
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
  bool exportTrackingInProgress = false;

  void _onSelectedItemChanged(int value) {
    setState(() => dateString = trackedDates[value]);
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(showOwnTrackProvider)) {
      return Container();
    }
    _updateDates();

    return Column(children: [
      CupertinoFormSection(
          header: Text(Localize.of(context).exportUserTrackingHeader),
          children: <Widget>[
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .9,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TintedCupertinoButton(
                        child: exportTrackingInProgress
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.edit),
                        onPressed: () async {
                          openDatePicker(context);
                        }),
                    Expanded(
                      child: GestureDetector(
                          child: Text(dateString),
                          onTap: () {
                            openDatePicker(context);
                          }),
                    ),
                    TintedCupertinoButton(
                        child: exportTrackingInProgress
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.map_rounded),
                        onPressed: () async {
                          if (exportTrackingInProgress) return;
                          setState(() {
                            exportTrackingInProgress = true;
                          });
                          var tp = await Future.microtask(() =>
                                  LocationStore.getUserTrackPointsListByDate(
                                      DateFormatter.fromString(dateString)))
                              .timeout(Duration(seconds: 120))
                              .catchError((error) {
                            BnLog.error(
                                text:
                                    'Future.microtask getUserTrackPointsListByDate failed $error',
                                exception: error);
                            return UserGPXPoints([]);
                          });
                          if (!context.mounted) {
                            setState(() {
                              exportTrackingInProgress = false;
                            });
                            return;
                          }
                          /*context.goNamed(AppRoute.userTrackDialog.name,
                              queryParameters: {
                                'userGPXPoints': tp.toJson(),
                                'date': dateString
                              });*/
                          UserTrackDialog.show(context, tp, dateString);
                          setState(() {
                            exportTrackingInProgress = false;
                          });
                        }),
                  ]),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: TintedCupertinoButton(
                  child: exportTrackingInProgress
                      ? const CircularProgressIndicator()
                      : Text(Localize.of(context).exportUserTracking),
                  onPressed: () async {
                    if (exportTrackingInProgress) return;
                    setState(() {
                      exportTrackingInProgress = true;
                    });
                    await LocationProvider().saveLocationToDB();
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
            ),
            if (!HiveSettingsDB.useAlternativeLocationProvider) ...[
              CupertinoFormSection(
                  header: Text(Localize.of(context).resetOdoMeter),
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: TintedCupertinoButton(
                        child: Text(Localize.of(context).resetOdoMeterTitle),
                        onPressed: () async {
                          await LocationProvider().resetOdoMeter(context);
                          setState(() {});
                        },
                      ),
                    ),
                  ]),
              CupertinoFormSection(
                  header: Text(Localize.of(context).resetTrackPointsStoreTitle),
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: TintedCupertinoButton(
                        child: Text(Localize.of(context).resetTrackPointsStore),
                        onPressed: () async {
                          await clearAllTrackPoints();
                          setState(() {});
                        },
                      ),
                    ),
                  ]),
            ],
          ]),
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
          context.pop();
        });
  }

  void _updateDates() {
    trackedDates = LocationStore.getTrackDates();
    if (dateString.isEmpty || dateString.length == 1) {
      dateString = trackedDates.last;
    }
  }

  void openDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StringPicker(
        title: Localize.of(context).selectDate,
        items: LocationStore.getTrackDates(),
        selectedItem: trackedDates.indexOf(dateString),
        onSelectedItemChanged: _onSelectedItemChanged,
      ),
    );
  }
}
