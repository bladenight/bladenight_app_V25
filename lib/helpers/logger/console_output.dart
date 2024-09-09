import 'package:logger/logger.dart';

class ConsoleLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print('ConsoleLog $line');
    }
  }
}
