import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart' show Lock;
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as path;

class FileLogger {
  final _lock = Lock();
  final _startTime = DateTime.now();
  String _logText = '';
  Timer? _writeFileTimer;

  FileLogger(this.directory) {
    _init();
  }

  File? file;
  Directory directory;

  Future<void> _init() async {
    try {
      _writeFileTimer = Timer(Duration(seconds: 5), _writeLog);
      //file = await getFile();
    } catch (e) {
      print("Can't open logfile getLogDir_logger.txt ${e.toString()}");
      return;
    }
  }

  Future<void> destroy() {
    try {
      _lock.synchronized(timeout: Duration(milliseconds: 500), () async {
        file = null;
      });
    } catch (_) {}
    file = null;
    _writeFileTimer?.cancel();
    return Future.value();
  }

  void output(String event, String level) async {
    runZonedGuarded(() {
      final diff = DateTime.now().difference(_startTime).toString();
      _lock.synchronized(timeout: Duration(milliseconds: 1000), () async {
        _logText +=
            '[${DateTime.now().toIso8601String()}] # Runtime :$diff # [$level] # \n$event\n##';
      });
    }, (error, stack) {
      print('[${DateTime.now().toIso8601String()}] error write string');
    });
  }

  Future<List<FileSystemEntity>> _collectLogFiles() async {
    try {
      return directory.list().toList();
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<List<String>> _txtFilesInDirectory(Directory logfilePath) async {
    List<String> files = [];
    final match = RegExp(r'^[0-9]+$');
    await for (var file
        in logfilePath.list(recursive: true, followLinks: false)) {
      if (path.extension(file.path) == '.txt') {
        final filename = path.basenameWithoutExtension(file.path);
        if (match.hasMatch(filename)) {
          files.add(file.absolute.path);
        }
      }
    }

    return files;
  }

  //clears all logfiles
  Future<bool> emptyLogs() async {
    try {
      _lock.synchronized(timeout: Duration(milliseconds: 2000), () async {
        var logFiles = await _collectLogFiles();
        for (var logFile in logFiles) {
          var file = File(logFile.path);

          try {
            await file.delete();
          } catch (e) {
            print('Logfile rotation ${file.path} could not been delete');
          }
        }
      });
    } catch (_) {}
    return Future.value(true);
  }

  Future<bool> clearLogs() async {
    try {
      _lock.synchronized(timeout: Duration(milliseconds: 2000), () async {
        var logFiles = await _collectLogFiles();
        for (var logFile in logFiles) {
          var file = File(logFile.path);
          if (wantDeleteFile(file)) {
            try {
              await file.delete();
            } catch (e) {
              print('Logfile rotation ${file.path} could not been delete');
            }
          }
        }
      });
    } catch (_) {}
    return Future.value(true);
  }

  bool wantDeleteFile(File file) {
    try {
      final filename = path.basenameWithoutExtension(file.path);
      var date = DateTime.tryParse((filename.split('_'))[0]);
      if (date != null) {
        return wantsDeleteFromDateTime(date);
      }
    } catch (_) {}
    return true;
  }

  bool wantsDeleteFromDateTime(DateTime created) {
    final diff = DateTime.now().difference(created);
    return diff.inDays > 8;
  }

  @visibleForTesting
  String createFileName() => '${DateTime.now().microsecondsSinceEpoch}.log';

  void _writeLog() {
    if (_logText.isEmpty) {
      return;
    }
    runZonedGuarded(() {
      final ds = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final logfilePath = '${directory.path}/${ds}_logger.txt';
      var toWrite = _logText.toString();
      _logText = '';
      try {
        _lock.synchronized(timeout: Duration(milliseconds: 3000), () async {
          var logFile = File(logfilePath);

          await logFile.writeAsString(toWrite,
              mode: FileMode.writeOnlyAppend, flush: true);
        });
      } catch (e) {
        print(
            '[${DateTime.now().toIso8601String()}] error write logfile $logfilePath $e');
      }
    }, (error, stack) {
      print('[${DateTime.now().toIso8601String()}] error write logfile');
    });
  }
}
