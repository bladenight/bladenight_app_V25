import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ConsoleLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
     if(kDebugMode){ print(line);}
    }
  }
}
