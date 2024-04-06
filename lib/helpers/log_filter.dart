import 'package:logger/logger.dart';

/// Prints all logs with `level >= Logger.level` while in development mode (eg
/// when `assert`s are evaluated, Flutter calls this debug mode).
///
/// In release mode ALL logs are omitted.
class BnLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.value >= level!.value) {
      // 0 all //off 10000
      return true;
    }
    return false;
  }
}
/*
*  all(0),
  @Deprecated('[verbose] is being deprecated in favor of [trace].')
  verbose(999),
  trace(1000),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  @Deprecated('[wtf] is being deprecated in favor of [fatal].')
  wtf(5999),
  fatal(6000),
  @Deprecated('[nothing] is being deprecated in favor of [off].')
  nothing(9999),
  off(10000),*/
