import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/device_id_helper.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/notification/toast_notification.dart';
import '../../../helpers/time_converter_helper.dart';
import '../../../models/event.dart';
import '../../../models/messages/edit_event_on_server.dart';
import '../../../models/route.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../../providers/event_providers.dart';
import '../../../providers/route_providers.dart';
import '../../../wamp/admin_calls.dart';
import '../../admin/widgets/event_status_selector.dart';
import '../../admin/widgets/route_name_selector.dart';
import '../../widgets/input/input_double_dialog.dart';
import '../../widgets/input/input_text_alert_dialog.dart';
import '../../widgets/common_widgets/no_connection_warning.dart';
import '../../widgets/input/input_int_dialog.dart';

class EventEditor extends ConsumerStatefulWidget {
  const EventEditor({required this.event, super.key});

  final Event event;

  static Future<Event?> show(BuildContext context, Event event) {
    return context.pushNamed(AppRoute.eventEditorPage.name, extra: event);
  }

  @override
  ConsumerState<EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends ConsumerState<EventEditor> {
  Event _event = Event.init;
  bool isUpdating = false;
  bool isSaving = false;

  @override
  void initState() {
    _event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () async {
                  context.pop();
                },
                child: const Icon(CupertinoIcons.back),
              ),
              largeTitle: Text(Localize.of(context).editEvent),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () async {
                  await _saveEvent();
                },
                child: const Icon(Icons.save_alt),
              ),
            ),
            isSaving
                ? const SliverToBoxAdapter(child: LinearProgressIndicator())
                : SliverFillRemaining(
                    fillOverscroll: true,
                    hasScrollBody: true,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ConnectionWarning(),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        CupertinoListTile(
                            title: Text(
                              Localize.of(context).selectDate,
                            ),
                            trailing:
                                Text(_event.startDate.toDeDateOnlyString()),
                            onTap: () async {
                              var datePicked = await showDatePicker(
                                context: context,
                                fieldLabelText: 'Eventdatum wählen',
                                //pickerMode: DateTimePickerMode.datetime,
                                // initialDate: DateTime(2020),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 366 * 100)),
                                lastDate: DateTime(2050),
                                //dateFormat: 'dd.MM.yyyy',
                                locale: const Locale('de', 'DE'),
                                //looping: true,
                              );
                              if (datePicked != null) {
                                var eventDate = _event.startDate;
                                _event = _event.copyWith(
                                    startDate: DateTime(
                                        datePicked.year,
                                        datePicked.month,
                                        datePicked.day,
                                        eventDate.hour,
                                        eventDate.minute,
                                        eventDate.second));
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        CupertinoListTile(
                          title: const Text('Zeit wählen'),
                          trailing: Text(
                              '${_event.startDate.toTimeOnlyString()} Uhr'),
                          onTap: () async {
                            var timePicked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _event.startDate.hour,
                                  minute: _event.startDate.minute),
                            );
                            if (timePicked != null) {
                              var eventDate = _event.startDate;
                              _event = _event.copyWith(
                                  startDate: DateTime(
                                      eventDate.year,
                                      eventDate.month,
                                      eventDate.day,
                                      timePicked.hour,
                                      timePicked.minute,
                                      0));
                              setState(() {});
                            }
                          },
                        ),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        //routename
                        CupertinoListTile(
                          title: Text(Localize.of(context).route),
                          trailing: Text(_event.routeName),
                          onTap: () async {
                            await RouteNameSelector.showRouteNameDialog(
                                context, _event.routeName, onChanged: (val) {
                              setState(() {
                                _event = _event.copyWith(routeName: val);
                              });
                            });
                            setState(() {
                              isUpdating = true;
                            });
                            var routePoints = await ref
                                .read(routeProvider(_event.routeName).future);
                            var routeLength =
                                (routePoints.getRouteTotalDistance).toInt();
                            _event = _event.copyWith(routeLength: routeLength);
                            isUpdating = false;
                            setState(() {});
                          },
                        ),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        CupertinoListTile(
                            title: Text(Localize.of(context).length),
                            trailing: isUpdating
                                ? const CircularProgressIndicator()
                                : Text('${_event.routeLength.toString()} m'),
                            onTap: isUpdating
                                ? null
                                : () async {
                                    var length = await InputNumberDialog.show(
                                        context, 'Routenlänge in m',
                                        initialValue: _event.routeLength);
                                    if (length != null) {
                                      _event =
                                          _event.copyWith(routeLength: length);
                                      setState(() {});
                                    }
                                  }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        //Dauer
                        CupertinoListTile(
                            title: const Text(
                              'Dauer',
                            ),
                            trailing: Text(
                                '${_event.duration.inMinutes.toString()} min'),
                            onTap: () async {
                              var durationPicked = await InputNumberDialog.show(
                                  context, 'Dauer in Minuten',
                                  initialValue: _event.duration.inMinutes);
                              if (durationPicked != null) {
                                _event = _event.copyWith(
                                    duration:
                                        Duration(minutes: durationPicked));
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        //Teilnehmer
                        CupertinoListTile(
                            title: const Text(
                              'EventStatus',
                            ),
                            trailing: Text(_event.statusText),
                            onTap: () async {
                              var eventStatus = await showEventStatusDialog(
                                  context,
                                  current: _event.status);
                              if (eventStatus != null) {
                                _event = _event.copyWith(status: eventStatus);
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        //Teilnehmer
                        CupertinoListTile(
                            title: const Text(
                              'Teilnehmerzahl',
                            ),
                            trailing: Text(_event.participants.toString()),
                            onTap: () async {
                              var participantsCount =
                                  await InputNumberDialog.show(
                                      context, 'Teilnehmeranzahl',
                                      initialValue: _event.participants,
                                      minValue: 0);
                              if (participantsCount != null) {
                                _event = _event.copyWith(
                                    participants: participantsCount);
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        //Teilnehmer
                        CupertinoListTile(
                            title: const Text(
                              'min. Bladeguardzahl',
                            ),
                            trailing: Text(_event.minBladeguards.toString()),
                            onTap: () async {
                              var minBladeguards = await InputNumberDialog.show(
                                  context, 'min. Bladeguardanzahl',
                                  initialValue: _event.minBladeguards,
                                  minValue: 0);
                              if (minBladeguards != null) {
                                _event = _event.copyWith(
                                    minBladeguards: minBladeguards);
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        CupertinoListTile(
                            title: const Text(
                              'Startpunkt',
                            ),
                            trailing: Text(_event.startPoint ?? ''),
                            onTap: () async {
                              var startPointVal = await InputTextDialog.show(
                                  context, 'Startpunkt',
                                  initialValue: null);
                              if (startPointVal != null) {
                                _event = _event.copyWith(
                                    startPoint: startPointVal.isEmpty
                                        ? null
                                        : startPointVal);
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        CupertinoListTile(
                            title: const Text(
                              'Sonderstart Latitude',
                            ),
                            trailing:
                                Text(_event.startPointLatitude.toString()),
                            onTap: () async {
                              var val = await InputDoubleDialog.show(
                                  context, 'Start Latitude',
                                  initialValue:
                                      _event.startPointLatitude ?? 0.0);
                              if (val != null) {
                                _event =
                                    _event.copyWith(startPointLatitude: val);
                                setState(() {});
                              }
                            }),
                        CupertinoListTile(
                            title: const Text(
                              'Sonderstart Longitude',
                            ),
                            trailing:
                                Text(_event.startPointLongitude.toString()),
                            onTap: () async {
                              var val = await InputDoubleDialog.show(
                                  context, 'Start Latitude',
                                  initialValue:
                                      _event.startPointLongitude ?? 0.0);
                              if (val != null) {
                                _event =
                                    _event.copyWith(startPointLongitude: val);
                                setState(() {});
                              }
                            }),
                        Divider(
                          thickness: 2,
                          height: 3,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CupertinoButton(
                            color: Colors.greenAccent,
                            onPressed: () async {
                              await _saveEvent();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.save_alt,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        Localize.of(context).save,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text('Änderungen sofort aktiv'),
                        SizedBox(
                          height: 40,
                        )
                      ]),
                    ),
                  ),
          ]),
    );
  }

  _saveEvent() async {
    setState(() {
      isSaving = true;
    });
    if (_event.duration < Duration(minutes: 1)) {
      _event = _event.copyWith(duration: Duration(minutes: 180));
    }
    var res = await AdminCalls.editEvent(
      EditEventOnServerMessage.authenticate(
        event: _event,
        deviceId: DeviceId.appId,
        password: HiveSettingsDB.serverPassword ?? '',
      ).toMap(),
    );
    setState(() {
      isSaving = false;
    });
    ref.invalidate(allEventsProvider);
    if (!res) {
      showToast(message: 'Fehler beim Speichern! $res');
    }
    if (mounted && context.mounted && res && context.canPop()) {
      showToast(message: 'Event gespeichert!'); //(context).pop(_event);
    }
  }
}
