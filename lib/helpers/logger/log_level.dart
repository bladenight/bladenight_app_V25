/// Copyright see talker pub.dev
/// Level of logs to segmentation and control logging output
enum LogLevel { critical, error, warning, info, debug, verbose, all }

/// List of levels sorted by priority
final logLevelPriorityList = [
  LogLevel.critical,
  LogLevel.error,
  LogLevel.warning,
  LogLevel.info,
  LogLevel.debug,
  LogLevel.verbose,
  LogLevel.all
];
