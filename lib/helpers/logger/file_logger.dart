import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as path;

import 'package:logger/logger.dart';

class FileLogger implements LogOutput {
  FileLogger(this.directory);

  File? file;
  Directory directory;

  @override
  Future<void> init() async {
    try {
      final ds = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var path = '${directory.path}/${ds}_logger.txt';
      if (file != null) {
        return;
      }
      file = File(path);
      await file
          ?.writeAsString('${DateTime.now().toIso8601String()} file init');
    } catch (e) {
      print("Can't open logfile getLogDir_logger.txt ${e.toString()}");
      return;
    }
  }

  @override
  Future<void> destroy() {
    file = null;
    return Future.value();
  }

  @override
  void output(OutputEvent event) async {
    var logString = '';
    if (file != null) {
      for (var line in event.lines) {
        logString += '${line.toString()}\n';
      }
      if (logString.isNotEmpty) {
        await file?.writeAsString(logString, mode: FileMode.writeOnlyAppend);
      }
    } else {
      for (var line in event.lines) {
        print(line);
      }
    }
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

  Future<bool> clearLogs() async {
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
    return Future.value(true);
  }

  bool wantDeleteFile(File file) {
    final filename = path.basenameWithoutExtension(file.path);
    final created = DateTime.fromMicrosecondsSinceEpoch(int.parse(filename));
    return wantsDeleteFromDateTime(created);
  }

  bool wantsDeleteFromDateTime(DateTime created) {
    final diff = DateTime.now().difference(created);
    return diff.inDays > 8;
  }

  @visibleForTesting
  String createFileName() => '${DateTime.now().microsecondsSinceEpoch}.log';
}
