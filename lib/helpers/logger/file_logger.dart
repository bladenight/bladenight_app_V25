import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart' show Lock;
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as path;

class FileLogger {
  final _lock = Lock();

  FileLogger(this.directory);

  File? file;
  Directory directory;

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

  Future<void> destroy() {
    file = null;
    return Future.value();
  }

  void output(String event) {
    _lock.synchronized(() async {
      if (file != null) {
        if (event.isNotEmpty) {
          await file?.writeAsString(event, mode: FileMode.writeOnlyAppend);
        }
      } else {
        print(event);
      }
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
}
