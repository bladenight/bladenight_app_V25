import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../generated/l10n.dart';
import '../../helpers/deviceid_helper.dart';
import '../../helpers/logger.dart';
import '../../helpers/timeconverter_helper.dart';
import '../../models/event.dart';
import '../../models/messages/kill_server.dart';
import '../../models/messages/set_active_route.dart';
import '../../models/messages/set_active_status.dart';
import '../../models/messages/set_procession_mode.dart';
import '../../pages/widgets/no_data_warning.dart';
import '../../providers/active_event_provider.dart';
import '../../providers/get_all_routes_provider.dart';
import '../../providers/route_providers.dart';
import '../../wamp/admin_calls.dart';
import '../widgets/no_connection_warning.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({required this.password, super.key});

  final String password;

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  bool _activityVisible = false;
  bool _resultTextVisibility = false;
  String _resultText = '';

  @override
  Widget build(BuildContext context) {
    var nextEventProvider = context.watch(activeEventProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(1),
        middle: const Text('Admin'),
      ),
      child: CupertinoScrollbar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: _activityVisible,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.green,
                ),
              ),
            ),
            Text(Localize.of(context).nextEvent,
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.textStyle),
            const SizedBox(height: 5),
            FittedBox(
              child: Text(
                  '${Localize.of(context).route} ${nextEventProvider.routeName}',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
              child: FittedBox(
                child: Text(
                    DateFormatter(Localize.of(context))
                        .getLocalDayDateTimeRepresentation(
                            nextEventProvider.getUtcIso8601DateTime),
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: nextEventProvider.status == EventStatus.cancelled
                      ? Colors.redAccent
                      : nextEventProvider.status == EventStatus.confirmed
                          ? Colors.green
                          : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(nextEventProvider.statusText,
                      style:
                          CupertinoTheme.of(context).textTheme.pickerTextStyle),
                ),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            const ConnectionWarning(),
            CupertinoButton.filled(
              child: Text(Localize.of(context).setState),
              onPressed: () async {
                var status = await showStatusDialog(
                  context,
                  current: context.read(activeEventProvider).status,
                );

                if (status != null) {
                  try {
                    setState(() => _activityVisible = true);
                    await AdminCalls.setActiveStatus(
                      SetActiveStatusMessage.authenticate(
                        status: status,
                        deviceId: DeviceId.appId,
                        password: widget.password,
                      ).toMap(),
                    );
                  } catch (e) {
                    BnLog.error(
                        text: 'SetActiveStatusMessage failed', exception: e);
                  }
                  setState(() => _activityVisible = false);
                  Future.delayed(const Duration(seconds: 1), () {
                    context.read(activeEventProvider.notifier).refresh();
                    context.read(currentRouteProvider);
                  });
                }
              },
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: _resultTextVisibility,
              child: Center(
                child: Text(_resultText),
              ),
            ),
            CupertinoButton.filled(
              child: Text(Localize.of(context).setRoute),
              onPressed: () async {
                var route = await showRouteDialog(
                  context,
                  current: context.read(currentRouteProvider).value?.name,
                );

                if (route != null) {
                  try {
                    setState(() => _activityVisible = true);
                    await AdminCalls.setActiveStatus(
                      SetActiveStatusMessage.authenticate(
                        status: EventStatus.cancelled,
                        deviceId: DeviceId.appId,
                        password: widget.password,
                      ).toMap(),
                    );
                    await Future.delayed(const Duration(milliseconds: 500));
                    await AdminCalls.setActiveRoute(
                      SetActiveRouteMessage.authenticate(
                        route: route,
                        deviceId: DeviceId.appId,
                        password: widget.password,
                      ).toMap(),
                    );
                    await Future.delayed(const Duration(milliseconds: 1000));
                    await AdminCalls.setActiveStatus(
                      SetActiveStatusMessage.authenticate(
                        status: EventStatus.confirmed,
                        deviceId: DeviceId.appId,
                        password: widget.password,
                      ).toMap(),
                    );
                  } catch (e) {
                    if (!kIsWeb) {
                      BnLog.error(
                          text: 'Error setroute',
                          className: toString(),
                          methodName: 'Adminpage Setroute');
                    }
                  }
                  setState(() => _activityVisible = false);
                  setState(
                      () => _resultText = Localize.of(context).sendData30sec);
                  setState(() => _resultTextVisibility = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => _resultTextVisibility = false);
                  var routeRes = ref.read(currentRouteProvider);
                  var eventRes = ref.read(activeEventProvider);
                  if (!kIsWeb) {
                    BnLog.info(
                        text: 'Admin set route $routeRes,event $eventRes');
                  }
                } else {
                  setState(() =>
                      _resultText = Localize.of(context).noChoiceNoAction);
                  setState(() => _resultTextVisibility = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => _resultTextVisibility = false);
                }
              },
            ),
            const SizedBox(height: 15),
            CupertinoButton.filled(
              child: const Text('ProcessionMode'),
              onPressed: () async {
                setState(() {
                  _activityVisible = false;
                });
                var status = await showProcessionModeDialog(
                  context,
                  current: null,
                );

                if (status != null) {
                  try {
                    await AdminCalls.setProcessionMode(
                        SetProcessionModeMessage.authenticate(
                                deviceId: DeviceId.appId,
                                password: widget.password,
                                mode: status)
                            .toMap());
                  } catch (e) {
                      BnLog.error(
                          text: 'Error ProcessionMode',
                          className: toString(),
                          methodName: 'Adminpage ProcessionMode');
                  }

                  setState(() {
                    _activityVisible = false;
                    _resultText = 'ProcessionMode Server sent!';
                  });

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            CupertinoButton.filled(
              child: const Text('Restart BN-Server'),
              onPressed: () async {
                var status = await showKillServerDialog(
                  context,
                  current: 0,
                );

                if (status != null && status == 1) {
                  try {
                    await AdminCalls.killServer(KillServerMessage.authenticate(
                      deviceId: DeviceId.appId,
                      password: widget.password,
                    ).toMap());
                  } catch (e) {
                      BnLog.error(
                          text: 'Error Restart Server',
                          className: toString(),
                          methodName: 'Adminpage Restart server');
                  }

                  _activityVisible = false;
                  _resultText = 'Restart Server sent!';
                  setState(() {});

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            SizedBox(height: 15 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

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
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                Navigator.of(context).pop(status);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> showRouteDialog(BuildContext context, {String? current}) {
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
              var routeNames = context.watch(getAllRouteNamesProvider);
              return routeNames.maybeWhen(
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                  data: (routeNames) {
                    if (routeNames.exception != null) {
                      return NoDataWarning(
                        onReload: () => context.read(getAllRouteNamesProvider),
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
                      onReload: () => context.refresh(getAllRouteNamesProvider),
                    );
                  });
            }),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                Navigator.of(context).pop(route);
              },
            ),
          ],
        );
      },
    );
  }

  Future<AdminProcessionMode?> showProcessionModeDialog(BuildContext context,
      {AdminProcessionMode? current}) {
    AdminProcessionMode? status;
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
                status = AdminProcessionMode.values[value];
              },
              itemExtent: 50,
              children: [
                for (var status in AdminProcessionMode.values)
                  Center(
                    child: Text(status.toString()),
                  ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                Navigator.of(context).pop(status);
              },
            ),
          ],
        );
      },
    );
  }

  Future<int?> showKillServerDialog(BuildContext context, {int? current}) {
    int? status;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Wirklich killen'),
          content: SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: 0),
              onSelectedItemChanged: (int value) {
                status = value;
              },
              itemExtent: 50,
              children: [
                Center(child: Text(Localize.of(context).no)),
                Center(child: Text(Localize.of(context).yes)),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop(status);
              },
            ),
          ],
        );
      },
    );
  }
}
