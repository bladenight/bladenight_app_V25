import 'package:logger/logger.dart';

/// Prints all logs with `level >= Logger.level` while in development mode (eg
/// when `assert`s are evaluated, Flutter calls this debug mode).
///
/// In release mode ALL logs are omitted.
class BnLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.value <= level!.value) {
      // 0 all //off 10000
      return true;
    }
    return false;
  }
}
