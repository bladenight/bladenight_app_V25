import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'hive_box/hive_settings_db.dart';

class LoggerHelper {
  static LoggerHelper instance = LoggerHelper();

  Future<void> init() async {
    return _setUpLogs();
  }

  Future<void> _setUpLogs() async {
    var loglevel = LogLevel.values
        .where((element) => element.index == HiveSettingsDB.flogLogLevel);
    LogsConfig config = LogsConfig()
      ..isDebuggable = true
      ..customClosingDivider = '|'
      ..customOpeningDivider = '|'
      ..csvDelimiter = ','
      ..encryptionEnabled = false
      ..encryptionKey = ''
      ..isDevelopmentDebuggingEnabled = true
      ..activeLogLevel = loglevel.first // LogLevel.INFO
      ..formatType = FormatType.FORMAT_CSV
      ..logLevelsEnabled = [
        LogLevel.INFO,
        LogLevel.ERROR,
        LogLevel.TRACE,
        LogLevel.WARNING,
        LogLevel.SEVERE,
        LogLevel.ALL
      ]
      ..dataLogTypes = [
        DataLogType.DEVICE.toString(),
        DataLogType.NETWORK.toString(),
        DataLogType.LOCATION.toString(),
        DataLogType.ERRORS.toString(),
        DataLogType.NOTIFICATION.toString(),
        DataLogType.DEFAULT.toString(),
        DataLogType.DATABASE.toString(),
      ]
      ..timestampFormat = TimestampFormat.TIME_FORMAT_24_FULL;

    if (!kIsWeb) FLog.applyConfigurations(config);
    if (!kIsWeb) {
      FLog.info(
        className: toString(),
        methodName: 'setUpLogs',
        text: 'Setting up logs finished...Level:${getActiveLogLevel()}');
    }
  }

  LogLevel getActiveLogLevel() {
    return FLog.getDefaultConfigurations().activeLogLevel;
  }

  Future<LogLevel?> showLogLevelDialog(BuildContext context,
      {LogLevel? current}) {
    LogLevel? logLevel;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Set LogLevel'),
          content: SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: current?.index ?? 0),
              onSelectedItemChanged: (int value) {
                logLevel = LogLevel.values[value];
              },
              itemExtent: 50,
              children: [
                for (var status in LogLevel.values)
                  Center(child: Text(status.name)),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Save'),
              onPressed: () {
                if (logLevel != null) {
                  FLog.getDefaultConfigurations().activeLogLevel = logLevel!;
                  if (!kIsWeb) {
                    FLog.info(
                    text: 'Loglevel changed to ${logLevel?.name}',
                  );
                  }
                  HiveSettingsDB.setFlogLevel(logLevel!.index);

                  if (!kIsWeb) {
                    //FLOG LogLevel { ALL, TRACE, DEBUG, INFO, WARNING, ERROR, SEVERE, FATAL, OFF }
                    // bg LogLevel const int LOG_LEVEL_OFF = 0;
                    //   static const int LOG_LEVEL_ERROR = 1;
                    //   static const int LOG_LEVEL_WARNING = 2;
                    //   static const int LOG_LEVEL_INFO = 3;
                    //   static const int LOG_LEVEL_DEBUG = 4;
                    //   static const int LOG_LEVEL_VERBOSE = 5;
                    if (logLevel == LogLevel.ALL ||
                        logLevel == LogLevel.TRACE) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_VERBOSE));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_VERBOSE);
                    } else if (logLevel == LogLevel.DEBUG) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_DEBUG));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_DEBUG);
                    } else if (logLevel == LogLevel.INFO) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_INFO));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_INFO);
                    } else if (logLevel == LogLevel.WARNING) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_WARNING));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_WARNING);
                    } else if (logLevel == LogLevel.ERROR) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_ERROR));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_ERROR);
                    } else if (logLevel == LogLevel.OFF) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_OFF));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_OFF);
                    }
                  }
                }
                Navigator.of(context).pop(logLevel);
              },
            ),
          ],
        );
      },
    );
  }
}
