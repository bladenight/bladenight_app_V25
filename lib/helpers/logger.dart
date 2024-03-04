import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../generated/l10n.dart';
import '../main.dart';
import 'hive_box/hive_settings_db.dart';
import 'logger/bn_log_output.dart';
import 'logger/console_output.dart';
import 'logger/log_printer.dart';

class BnLog {
  static Logger _logger = Logger();
  static bool _isInitialized = false;
  static final List<LogOutput> _logOutputs = [];
  static late Box<List<String>> _logBox;
  static final DateTime  _startTime = DateTime.now();
  BnLog._(){
    if (_isInitialized == false){
      init();
    }
  }

  static init({Level? logLevel, LogFilter? filter}) async {
    _logBox = await Hive.openBox('logBox');
    _logBox.put('startLog', ['start logging']);
    //add logger
    _logOutputs.clear();

    _logOutputs.addAll({BnLogOutput(_logBox,_startTime), ConsoleLogOutput()});
    //_logger.close();
    _logger = Logger(
      filter: filter,
      output:  MultiOutput(_logOutputs),
      level: logLevel ?? HiveSettingsDB.flogLogLevel,
      printer: BnLogPrinter(
          logBox: _logBox,startTime: _startTime,
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: false,
          printEmojis: true,
          printTime: true,
          ),
    );
    _isInitialized = true;
  }

  static void debug({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logger.d('$text\n$className\n$methodName', error: exception);
  }

  ///Print extended info
  static void infoExt(String text,{
    String? className,
    String? methodName,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logger.i('$text\n$className\n$methodName', error: null, stackTrace: null);
  }

  static void info({
    String? className,
    String? methodName,
    required String text,
    /*dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,*/
  }) async {
    _logger.i('$text\n$className\n$methodName', error: null, stackTrace: null);
  }

  static void warning({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    String? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logger.w(
        '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}',
        error: exception,
        stackTrace: stacktrace);
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
  static void trace({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    StackTrace? stacktrace,
  }) async {
    _logger.t(
        '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}',
        error: exception,
        stackTrace: stacktrace);
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
    _logger.e(
        '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}',
        error: exception,
        stackTrace: stacktrace);
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
    _logger.f(
        '$text'
        '${className != null ? '\nc:$className' : ""}'
        '${methodName != null ? '\nm:$methodName' : ""}',
        error: exception,
        stackTrace: stacktrace);
  }

  static Future<String> exportLogs() async {
    await _logBox.flush();
    var resString = '';
    for (var key in _logBox.keys) {
      var val = _logBox.get(key);
      if (val != null) {
        resString = '$resString$val\n';
      }
    }
    return resString;
  }

  static Future<bool> clearLogs() async {
    for (var key in _logBox.keys) {
      await _logBox.delete(key);
    }
    BnLog.info(text: 'Cleared logs');
    return Future(() => true);
  }

  ///
  /// endTimeInMillis
  static Future<bool> cleanUpLogsByFilter(Duration deleteOlderThan) async {
    var leftDate =
        DateTime.now().subtract(deleteOlderThan).millisecondsSinceEpoch;
    for (var key in _logBox.keys) {
      var intVal = int.tryParse(key);
      if (intVal!=null && intVal < leftDate) {
        await _logBox.delete(key);
      }
    }
    BnLog.info(text: 'Cleared logs before $leftDate');
    return Future(() => true);
  }

  static Level getActiveLogLevel() {
    return HiveSettingsDB.flogLogLevel;
  }

  static void setActiveLogLevel(Level logLevel) {
    //_logger.close();
    HiveSettingsDB.setFlogLevel(logLevel);
    initLogger();
  }

  static Future<Level?> showLogLevelDialog(BuildContext context,
      {Level? current}) {
    Level? logLevel;
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
                logLevel = Level.values[value];
              },
              itemExtent: 50,
              children: [
                for (var status in Level.values)
                  Center(child: Text(status.name)),
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
                if (logLevel != null) {
                  BnLog.setActiveLogLevel(logLevel!);
                  if (!kIsWeb) {
                    BnLog.info(
                      text: 'Loglevel changed to ${logLevel?.name}',
                    );
                  }
                  HiveSettingsDB.setFlogLevel(logLevel!);

                  if (!kIsWeb) {
                    if (logLevel == Level.all || logLevel == Level.trace) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_VERBOSE));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_VERBOSE);
                    } else if (logLevel == Level.debug) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_DEBUG));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_DEBUG);
                    } else if (logLevel == Level.info) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_INFO));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_INFO);
                    } else if (logLevel == Level.warning) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_WARNING));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_WARNING);
                    } else if (logLevel == Level.error) {
                      bg.BackgroundGeolocation.setConfig(
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_ERROR));
                      HiveSettingsDB.setBackgroundLocationLogLevel(
                          bg.Config.LOG_LEVEL_ERROR);
                    } else if (logLevel == Level.off) {
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
