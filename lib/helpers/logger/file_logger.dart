import 'package:universal_io/io.dart';

import 'package:logger/logger.dart';

class FileLogger extends LogOutput {
  FileLogger(this.filePath);

  File? file;
  String filePath;

  @override
  Future<void> init() async {
    super.init();
    if (file != null) {
      return;
    }
    file = File(filePath);
    await file?.writeAsString('${DateTime.now().toIso8601String()} file init');
  }

  @override
  Future<void> destroy() {
    return super.destroy();
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
}
