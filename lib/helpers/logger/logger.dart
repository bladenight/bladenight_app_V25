import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';
import 'package:universal_io/io.dart';

import '../../app_settings/server_connections.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../hive_box/hive_settings_db.dart';
import 'file_logger.dart';

class BnLog {
  static FileLogger? fileLogger;
  static final Talker _talkerLogger = talker;
  static LogLevel _logLevel = kDebugMode ? LogLevel.verbose : LogLevel.info;

  static final DateTime _startTime = DateTime.now();

  BnLog._() {
    init();
  }

  static Timer? _timer;

  static Future<bool?> clearLogs() async {
    talker.cleanHistory();
    return fileLogger?.clearLogs();
  }

  static Future<bool?> clearOlderLogs() async {
    return fileLogger
        ?.wantsDeleteFromDateTime(DateTime.now().subtract(Duration(days: 15)));
  }

  static Future<Directory> _getLogDir() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    var logDir = '${appDirectory.path}/log';
    return await Directory(logDir).create();
  }

  static void close() {
    fileLogger?.output(
        '${DateTime.now().toIso8601String()}AppClosed', LogLevel.info.name);
    _timer?.cancel();
  }

  static Future<bool> init({LogLevel? logLevel}) async {
    await Hive.initFlutter();
    try {
      if (kDebugMode || kProfileMode || localTesting) {
        logLevel = LogLevel.verbose;
      }
      logLevel = HiveSettingsDB.flogLogLevel;
      if (!kIsWeb) {
        fileLogger = FileLogger(await _getLogDir());
      }
      _timer = Timer(Duration(minutes: 5000), clearOlderLogs);
      return true;
    } catch (e) {
      print('Error init logger $error');
      return false;
    }
  }

  static void debug({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    //critical 0 // info 3 verbose 5
    if (_logLevel.index < logLevelPriorityList.indexOf(LogLevel.debug)) return;
    var logText = '$text\nclass:$className\nmethod:$methodName';
    _talkerLogger.debug(logText);
    fileLogger?.output(logText, LogLevel.debug.name);
  }

  ///Print extended info
  static void infoExt(
    String text, {
    String? className,
    String? methodName,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    //critical 0 // info 3 verbose 5
    if (_logLevel.index < logLevelPriorityList.indexOf(LogLevel.info)) return;
    _talkerLogger.info(text);
    fileLogger?.output(text, LogLevel.info.name);
  }

  static void info({
    String? className,
    String? methodName,
    required String text,
  }) async {
    //critical 0 // info 3 verbose 5
    if (_logLevel.index < logLevelPriorityList.indexOf(LogLevel.info)) return;
    _talkerLogger.info(text);
    fileLogger?.output(text, LogLevel.info.name);
  }

  static void warning({
    String? className,
    String? methodName,
    required String text,
    String? dataLogType,
  }) async {
    var logText = '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}';
    _talkerLogger.warning(logText);
    fileLogger?.output(logText, LogLevel.warning.name);
  }

  /// trace
  ///
  /// Logs 'String' data along with class & function
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  /// @param exception  the exception if thrown
  /// @param stacktrace  the stacktrace if wanted
  static void verbose({
    String? className,
    String? methodName,
    required String text,
  }) async {
    //critical 0 // info 3 verbose 5
    if (_logLevel.index < logLevelPriorityList.indexOf(LogLevel.verbose)) {
      return;
    }
    var logText = '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}';
    _talkerLogger.verbose(logText);
    fileLogger?.output(logText, LogLevel.verbose.name);
  }

  /// error
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void error({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    //critical 0 // info 3 verbose 5
    if (_logLevel.index < logLevelPriorityList.indexOf(LogLevel.error)) return;
    var logText = '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}'
        '${exception != null ? '\nex:${exception.toString()}' : ""}'
        '${stacktrace != null ? '\nex:$stacktrace' : ""}';
    _talkerLogger.error(logText);
    fileLogger?.output(logText, LogLevel.error.name);
  }

  /// fatal
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void fatal({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    //always written
    var logText = '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}'
        '${exception != null ? '\nex:${exception.toString()}' : ""}'
        '${stacktrace != null ? '\nex:$stacktrace' : ""}';
    _talkerLogger.critical(logText);
    fileLogger?.output(logText, LogLevel.critical.name);
  }

  static Future<List<FileSystemEntity>> collectLogFiles() async {
    try {
      final directory = await _getLogDir();
      return directory.list().toList();
    } catch (e) {
      return Future.value([]);
    }
  }

  ///executed in isolate
  static Future<String> logValuesAsString(List<String> valList) async {
    return valList.reversed.join('\r\n');
  }

  ///Clean up log file and delete data's older than a week
  void cleanupLog() async {
    try {
      await BnLog.cleanUpLogsByFilter(const Duration(days: 8));
    } catch (e) {
      BnLog.warning(text: 'Error clearing logs');
    }
  }

  ///
  /// endTimeInMillis
  static Future<bool> cleanUpLogsByFilter(Duration deleteOlderThan) async {
    if (!await init()) {
      return Future.value(true);
    }

    return Future.value(true);
  }

  static LogLevel getActiveLogLevel() {
    return _logLevel;
  }

  static void setActiveLogLevel(LogLevel logLevel) async {
    _logLevel = logLevel;
    _talkerLogger.info('Loglevel changed to ${logLevel.name}');
    HiveSettingsDB.setFlogLevel(logLevel);
  }

  static Future<LogLevel?> showLogLevelDialog(BuildContext context,
      {LogLevel? current}) {
    LogLevel? logLevel;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(Localize.of(context).setLogLevel),
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
              child: Text(Localize.of(context).cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                if (logLevel != null) {
                  BnLog.setActiveLogLevel(logLevel!);

                  if (!kIsWeb) {
                    if (logLevel == LogLevel.verbose) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_VERBOSE));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_VERBOSE);
                    } else if (logLevel == LogLevel.debug) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_DEBUG));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_DEBUG);
                    } else if (logLevel == LogLevel.info) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_INFO));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_INFO);
                    } else if (logLevel == LogLevel.warning) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_WARNING));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_WARNING);
                    } else if (logLevel == LogLevel.error) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_ERROR));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_ERROR);
                    } /*else if (logLevel == LogLevel.info) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_OFF));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_OFF);
                    }*/
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
