import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class BnLogOutput extends LogOutput {
  final LazyBox<String> _logBox;
  final DateTime _startTime;

  BnLogOutput(this._logBox, this._startTime);

  @override
  void output(OutputEvent event) {
    _logToHiveBox(
        event.origin.level,
        event.origin.message,
        event.origin.time.toIso8601String(),
        event.origin.error?.toString(),
        event.origin.stackTrace?.toString());
    //print(event.lines);
  }

  @override
  Future<void> destroy() async {
    _logBox.flush();
    _logBox.close();
  }

  _logToHiveBox(
    Level level,
    String message,
    String? time,
    String? error,
    String? stacktrace,
  ) {
    List<String> buffer = [];
    String key = DateTime.now().millisecondsSinceEpoch.toString();
    if (time != null) {
      buffer.add(' $time ${level.toString()}');
    } else {
      buffer.add(' ${getTime(DateTime.now())} ${level.toString()}');
    }

    for (var line in message.split('\n')) {
      if (message == 'null') {
        continue;
      }
      buffer.add(line);
    }

    if (error != null) {
      buffer.add('Error:');
      for (var line in error.split('\n')) {
        buffer.add(line);
      }
    }

    if (stacktrace != null) {
      buffer.add('Error:');
      for (var line in stacktrace.split('\n')) {
        buffer.add(line);
      }
    }
    _logBox.put(key, buffer.join(';'));
  }

  String getTime(DateTime time) {
    String threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = time;
    var h = twoDigits(now.hour);
    var min = twoDigits(now.minute);
    var sec = twoDigits(now.second);
    var ms = threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime).toString();
    return '$h:$min:$sec.$ms (+$timeSinceStart)';
  }
}
