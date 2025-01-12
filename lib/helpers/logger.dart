import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import '../app_settings/server_connections.dart';
import '../generated/l10n.dart';
import 'hive_box/hive_settings_db.dart';
import 'log_filter.dart';
import 'logger/console_output.dart';
import 'logger/file_logger.dart';
import 'logger/log_printer.dart';

class BnLog {
  static Logger _logger = Logger();
  static final List<LogOutput> _logOutputs = [];

  //static late LazyBox<String>? _logBox;
  static final DateTime _startTime = DateTime.now();

  BnLog._() {
    init();
  }

  static Future<Directory> _getLogDir() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    var logDir = '${appDirectory.path}/log/';
    return await Directory(logDir).create();
  }

  static void flush() {
    //if (_logBox != null && _logBox!.isOpen) _logBox?.flush();
  }

  static void close() {
    /* if (_logBox != null && _logBox!.isOpen) _logBox?.flush();
    _logBox?.close();
    _logBox = null;*/
  }

  static Future<bool> init({Level? logLevel, LogFilter? filter}) async {
    await Hive.initFlutter();
    try {
      //if (!Hive.isBoxOpen(hiveBoxLoggingDbName) || _logBox == null) {
      //_logBox = await Hive.openLazyBox<String>(hiveBoxLoggingDbName).timeout(Duration(seconds: 5));
      // if (_logBox != null) {
      //add logger
      _logOutputs.clear();
      //_logOutputs.add(BnLogOutput(_logBox!, _startTime));

      if (kDebugMode || kProfileMode || localTesting) {
        _logOutputs.add(ConsoleLogOutput());
      }

      try {
        final directory = await _getLogDir();
        final ds = DateFormat('yyyy-MM-dd').format(DateTime.now());
        _logOutputs.add(FileLogger('${directory.path}/${ds}_logger.txt'));
      } catch (e) {
        print("Can't open logfile getLogDir_logger.txt ${e.toString()}");
        return false;
      }

      //_logger.close();
      _logger = Logger(
        filter: BnLogFilter(), //important for logging in release version
        output: MultiOutput(_logOutputs),
        level: logLevel ?? HiveSettingsDB.flogLogLevel,
        printer: BnLogPrinter(
          startTime: _startTime,
          methodCount: 3,
          errorMethodCount: 8,
          lineLength: 120,
          colors: false,
          printEmojis: false,
          printTime: true,
        ),
      );
      _logger.i(
          '${DateTime.now().toIso8601String()} Started logging ${logLevel ?? HiveSettingsDB.flogLogLevel}');

      return true;
    } catch (e) {
      print('error open logBox $error');
      return false;
    }
    return true;
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

  static Future<bool> clearLogs() async {
    if (await init() == true) {
      return Future.value(false);
    }
    var dir = _getLogDir();
    /* for (var key in _logBox!.keys) {
      await _logBox?.delete(key);
    }
    BnLog.info(text: 'Cleared logs');*/
    return Future.value(true);
  }

  ///
  /// endTimeInMillis
  static Future<bool> cleanUpLogsByFilter(Duration deleteOlderThan) async {
    if (!await init()) {
      return Future.value(true);
    }
    int counter = 0;
    var leftDate =
        DateTime.now().subtract(deleteOlderThan).millisecondsSinceEpoch;

    /* for (var key in _logBox!.keys) {
      var intVal = int.tryParse(key);
      if (intVal != null && intVal < leftDate) {
        await _logBox?.delete(key);
        counter++;
      }
    }
    BnLog.info(
        text:
            'Tidied up logs before ${DateTime.fromMillisecondsSinceEpoch(leftDate)}  - $counter entries removed');
    */
    return Future.value(true);
  }

  static Level getActiveLogLevel() {
    return HiveSettingsDB.flogLogLevel;
  }

  static void setActiveLogLevel(Level logLevel) async {
    HiveSettingsDB.setFlogLevel(logLevel);
    return;
    if (await init()) {
      return;
    }
    //await _logBox?.flush();
    //await _logBox?.close();
    init();
    BnLog.info(text: 'Loglevel changed to ${logLevel.name}');
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
