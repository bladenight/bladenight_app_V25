//source https://gist.github.com/mayor04/51b2b028a9fe11165e06ceb1353fe052

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:universal_io/io.dart';

import '../../generated/l10n.dart';
import '../../models/event.dart';
import '../logger.dart';
import '../timeconverter_helper.dart';
import 'received_notification.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _showNotification = true;

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  factory NotificationHelper() {
    return _instance;
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  NotificationHelper._internal() {
    if (kIsWeb) return;
    initialiseNotifications();
  }

  initialiseNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _configureLocalTimeZone();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(onDidReceiveLocalNotification: null);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotificationStream.add(notificationResponse.payload);

            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
  }

  ///Schedule a notification on device at scheduled time
  ///Important use [DateTime.utc] as scheduledDate
  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    if (kIsWeb) return;
    if (id > 2 ^ 31 || id < 2 ^ 31) {
      id = Random().nextInt(2 ^ 31);
    }
    var timeDiff =
        scheduledDate.toUtc().difference(DateTime.now().toUtc()).inMinutes;
    if (timeDiff < 1) {
      BnLog.warning(
          className: 'flutterLocalNotificationsPlugin',
          methodName: 'zonedSchedule',
          text: 'no notification set:$scheduledDate is not in future');
      return;
    }
    var tzTime = tz.TZDateTime.now(tz.UTC).add(Duration(minutes: timeDiff));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tzTime, _getPlatformSpecifics(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    if (!kIsWeb) {
      BnLog.info(
          className: 'flutterLocalNotificationsPlugin',
          methodName: 'zonedSchedule',
          text: 'Set notification:$tzTime');
    }
  }

  Future<void> cancelNotifications(int notificationId) async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  _show({
    required int id,
    required String title,
    required String body,
    String payload = '',
  }) async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _getPlatformSpecifics(),
      payload: payload,
    );
  }

  void showEventUpdated(
      {required int id, required Event event, String? title}) {
    if (kIsWeb) return;
    if (!_showNotification) return;
    if (event.status == EventStatus.cancelled) {
      _show(
          id: event.hashCode,
          title: Localize.current.note_bladenightCanceled,
          body:
              '${Localize.current.route}: ${event.routeName} ${DateFormatter(Localize.current).getLocalDayDateTimeRepresentation(event.getUtcIso8601DateTime)} '
              '${Localize.current.ist} ${Localize.current.canceled}');
    } else {
      _show(
        id: id,
        title: title ?? Localize.current.bladenightUpdate,
        body:
            '${Localize.current.route}: ${event.routeName} ${DateFormatter(Localize.current).getLocalDayDateTimeRepresentation(event.getUtcIso8601DateTime)} '
            '${Localize.current.status}: ${Intl.select(event.status, {
              EventStatus.pending: Localize.current.pending,
              EventStatus.confirmed: Localize.current.confirmed,
              EventStatus.cancelled: Localize.current.canceled,
              EventStatus.noevent: Localize.current.noEvent,
              EventStatus.running: Localize.current.running,
              EventStatus.finished: Localize.current.finished,
              'other': Localize.current.unknown
            })}',
      );
    }
  }

  void showString({required int id, required String text, String? title}) {
    if (kIsWeb) return;
    if (!_showNotification) return;
    _show(id: id, title: title ?? Localize.current.bladenight, body: text);
  }

  void updateNotifications(Event oldEvent, Event newEvent) {
    if (kIsWeb) return;
    if (oldEvent.compareTo(newEvent) != 0) {
      NotificationHelper().cancelAllNotifications();
      if (oldEvent.status != newEvent.status &&
          newEvent.status == EventStatus.cancelled) {
        showEventUpdated(
            id: newEvent.hashCode,
            event: newEvent,
            title: Localize.current.note_statuschanged);
        return;
      }
      /* if (newEvent.status == EventStatus.confirmed) {
        NotificationHelper().scheduleNotification(
            newEvent.hashCode,
            Localize.current.bladenight,
            Localize.current.note_bladenightStartInFiveMinutesStartTracking,
            newEvent.startDateUtc);
        return;
      }*/
    }
  }

  void resumeNotification() {
    _showNotification = true;
  }

  void pauseNotification() {
    _showNotification = false;
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    } catch (e) {
      print(e);
    }
  }

  NotificationDetails _getPlatformSpecifics() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'app.bn.notification',
      'bnnotification',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: false,
      timeoutAfter: 300000,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        presentAlert: true,
        // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentBadge: true,
        // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentSound: false,
        // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        sound: null,
        // Specifics the file path to play (only from iOS 10 onwards)
        badgeNumber: -1,
        // The application's icon badge number
        attachments: null,
        //(only from iOS 10 onwards)
        subtitle: '',
        //Secondary description  (only from iOS 10 onwards)
        threadIdentifier: 'app.bn.notification' // (only from iOS 10 onwards)
        );

    const DarwinNotificationDetails macOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
            presentAlert: true,
            // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentBadge: true,
            // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentSound: false,
            // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            sound: null,
            // Specifics the file path to play (only from iOS 10 onwards)
            badgeNumber: -1,
            // The application's icon badge number
            attachments: null,
            //(only from iOS 10 onwards)
            subtitle: '',
            //Secondary description  (only from iOS 10 onwards)
            threadIdentifier:
                'app.bn.notification' // (only from iOS 10 onwards)
            );

    NotificationDetails platformChannelSpecifics = const NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android: androidPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }
}
