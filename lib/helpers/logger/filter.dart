import 'package:logger/logger.dart';

class DebugLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level == Level.debug) {
      return true;
    } else {
      return false;
    }
  }
}
