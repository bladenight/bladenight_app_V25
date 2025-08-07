import 'package:flutter/material.dart';

import 'package:talker_flutter/talker_flutter.dart';

import 'talker_typed_monitor_log_screen.dart';

class TalkerMonitor extends StatelessWidget {
  const TalkerMonitor({
    super.key,
    required this.theme,
    required this.talker,
  });

  /// Theme for customize [TalkerScreen]
  final TalkerScreenTheme theme;

  /// Talker implementation
  final Talker talker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: TalkerScreen(
          talker: talker,
          isLogsExpanded: true,
          isLogOrderReversed:
              true), /*TalkerBuilder(
        talker: talker,
        builder: (context, data) {
          final logs = data.whereType<TalkerLog>().toList();
          final errors = data.whereType<TalkerError>().toList();
          final exceptions = data.whereType<TalkerException>().toList();
          final warnings =
              logs.where((e) => e.logLevel == LogLevel.warning).toList();

          final infos = logs.where((e) => e.logLevel == LogLevel.info).toList();
          final verboseDebug = logs
              .where((e) =>
                  e.logLevel == LogLevel.verbose ||
                  e.logLevel == LogLevel.debug)
              .toList();

          final httpRequests = data
              .where((e) => e.key == TalkerLogType.httpRequest.key)
              .toList();
          final httpErrors =
              data.where((e) => e.key == TalkerLogType.httpError.key).toList();
          final httpResponses = data
              .where((e) => e.key == TalkerLogType.httpResponse.key)
              .toList();
          final riverpodAddLogs = data
              .where((e) => e.key == TalkerLogType.riverpodAdd.key)
              .toList();
          final riverpodFailLogs = data
              .where((e) => e.key == TalkerLogType.riverpodFail.key)
              .toList();

          return CustomScrollView(
            slivers: [
              if (httpRequests.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    logs: httpRequests,
                    title: 'Http Requests',
                    color: Colors.green,
                    theme: theme,
                    icon: Icons.wifi,
                    subtitleWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '${httpRequests.length}',
                            style: const TextStyle(color: Colors.white),
                            children: const [
                              TextSpan(text: ' http requests executed')
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '${httpResponses.length} successful',
                            style: const TextStyle(color: Colors.green),
                            children: const [
                              TextSpan(
                                text: ' responses received',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '${httpErrors.length} failure',
                            style: const TextStyle(color: Colors.red),
                            children: const [
                              TextSpan(
                                text: ' responses received',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (errors.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: errors,
                    title: 'Errors',
                    color: theme.logColors.getByType(TalkerLogType.error),
                    icon: Icons.error_outline_rounded,
                    subtitle:
                        'Application has ${errors.length} unresolved errors',
                    onTap: () =>
                        _openTypedLogsScreen(context, errors, 'Errors'),
                  ),
                ),
              ],
              if (exceptions.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: exceptions,
                    title: 'Exceptions',
                    color: theme.logColors.getByType(TalkerLogType.exception),
                    icon: Icons.error_outline_rounded,
                    subtitle:
                        'Application has ${exceptions.length} unresolved exceptions',
                    onTap: () =>
                        _openTypedLogsScreen(context, exceptions, 'Exceptions'),
                  ),
                ),
              ],
              if (warnings.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: warnings,
                    title: 'Warnings',
                    color: theme.logColors.getByType(TalkerLogType.warning),
                    icon: Icons.warning_amber_rounded,
                    subtitle: 'Application has ${warnings.length} warnings',
                    onTap: () =>
                        _openTypedLogsScreen(context, warnings, 'Warnings'),
                  ),
                ),
              ],
              if (infos.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: infos,
                    title: 'Infos',
                    color: theme.logColors.getByType(TalkerLogType.info),
                    icon: Icons.info_outline_rounded,
                    subtitle: 'Info logs count: ${infos.length}',
                    onTap: () => _openTypedLogsScreen(context, infos, 'Infos'),
                  ),
                ),
              ],
              if (verboseDebug.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: verboseDebug,
                    title: 'Verbose & debug',
                    color: theme.logColors.getByType(TalkerLogType.verbose),
                    icon: Icons.remove_red_eye_outlined,
                    subtitle:
                        'Verbose and debug logs count: ${verboseDebug.length}',
                    onTap: () => _openTypedLogsScreen(
                      context,
                      verboseDebug,
                      'Verbose & debug',
                    ),
                  ),
                ),
              ],
              if (riverpodFailLogs.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: TalkerMonitorCard(
                    theme: theme,
                    logs: riverpodFailLogs,
                    title: 'Riverpod Fail',
                    color: theme.logColors.getByType(TalkerLogType.verbose),
                    icon: Icons.remove_red_eye_outlined,
                    subtitle:
                        'Riverpod fail logs count: ${riverpodFailLogs.length}',
                    onTap: () => _openTypedLogsScreen(
                      context,
                      riverpodFailLogs,
                      'Riverpod Fail',
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),*/
    );
  }

  void _openTypedLogsScreen(
    BuildContext context,
    List<TalkerData> logs,
    String typeName,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TalkerMonitorTypedLogsScreen(
          exceptions: logs,
          theme: theme,
          typeName: typeName,
        ),
      ),
    );
  }
}
