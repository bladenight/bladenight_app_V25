import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import 'hive_box/hive_settings_db.dart';
import 'log_filter.dart';
import 'logger/bn_log_output.dart';
import 'logger/console_output.dart';
import 'logger/log_printer.dart';

class BnLog {
  static const String dbName = hiveBoxLoggingDbName;
  static Logger _logger = Logger();
  static bool _isInitialized = false;
  static final List<LogOutput> _logOutputs = [];
  static late LazyBox<String>? _logBox;
  static final DateTime _startTime = DateTime.now();

  BnLog._() {
    if (_isInitialized == false) {
      init();
    }
  }

  static flush() {
    _logBox?.flush();
    _logBox?.close();
  }

  static init({Level? logLevel, LogFilter? filter}) async {
    print('logger.dart initLogger');
    await Hive.initFlutter();
    print('logger.dart open logbox');
    try {
      var logBox = await Hive.openLazyBox(dbName).timeout(Duration(seconds: 5));
      if (logBox.runtimeType == Box<String>) {
        _logBox = logBox as LazyBox<String>;
      } else {
        return;
      }
    } catch (e) {
      print('error open logBox $error');
      return null;
    }

    print('logger.dart put start');
    _logBox?.put(DateTime.now().millisecondsSinceEpoch.toString(),
        '${DateTime.now().toIso8601String()} Started logging ${logLevel ?? HiveSettingsDB.flogLogLevel}');
    //add logger
    _logOutputs.clear();
    _logOutputs.add(BnLogOutput(_logBox!, _startTime));
    if (kDebugMode || kProfileMode) {
      _logOutputs.add(ConsoleLogOutput());
    }

    //_logger.close();
    _logger = Logger(
      filter: BnLogFilter(), //important for logging in release version
      output: MultiOutput(_logOutputs),
      level: logLevel ?? HiveSettingsDB.flogLogLevel,
      printer: BnLogPrinter(
        logBox: _logBox!,
        startTime: _startTime,
        methodCount: 3,
        errorMethodCount: 8,
        lineLength: 120,
        colors: false,
        printEmojis: true,
        printTime: true,
      ),
    );
    _isInitialized = true;
    print('logger.dart ready');
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
  static void infoExt(
    String text, {
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

  static Future<String> collectLogs() async {
    //_logBox = Hive.box(dbName);
    _logBox = await Hive.openLazyBox(dbName);
    await _logBox?.flush();
    List<String> valList = [];
    if (_logBox == null) {
      return '';
    }
    for (var val in _logBox!.keys) {
      var str = await _logBox!.get(val as String);
      if (str != null) {
        valList.add(str);
      }
    }
    return await compute(logValuesAsString, valList);
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

  static Future<bool> clearLogs() async {
    await Hive.initFlutter();
    _logBox = await Hive.openLazyBox(dbName);
    if (_logBox == null) {
      return false;
    }
    for (var key in _logBox!.keys) {
      await _logBox?.delete(key);
    }
    BnLog.info(text: 'Cleared logs');
    return Future(() => true);
  }

  ///
  /// endTimeInMillis
  static Future<bool> cleanUpLogsByFilter(Duration deleteOlderThan) async {
    await Hive.initFlutter();
    _logBox = await Hive.openLazyBox(dbName);
    int counter = 0;
    var leftDate =
        DateTime.now().subtract(deleteOlderThan).millisecondsSinceEpoch;
    if (_logBox == null) {
      return false;
    }
    for (var key in _logBox!.keys) {
      var intVal = int.tryParse(key);
      if (intVal != null && intVal < leftDate) {
        await _logBox?.delete(key);
        counter++;
      }
    }
    BnLog.info(
        text:
            'Tidied up logs before ${DateTime.fromMillisecondsSinceEpoch(leftDate)}  - $counter entries removed');
    return Future(() => true);
  }

  static Level getActiveLogLevel() {
    return HiveSettingsDB.flogLogLevel;
  }

  static void setActiveLogLevel(Level logLevel) async {
    //_logger.close();
    HiveSettingsDB.setFlogLevel(logLevel);
    BnLog.info(text: 'Loglevel changed to ${logLevel.name}');
    await Hive.initFlutter();
    _logBox = await Hive.openLazyBox(dbName);
    await _logBox?.flush();
    await _logBox?.close();
    init();
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
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(Localize.of(context).save),
              onPressed: () {
                if (logLevel != null) {
                  BnLog.setActiveLogLevel(logLevel!);

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
                          bg.Config(logLevel: bg.Config.LOG_LEVEL_OFF));
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
