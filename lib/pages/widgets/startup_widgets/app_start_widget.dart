//Copyright (c) 2019 Andrea Bizzotto bizz84@gmail.com
//parts from
//https://github.com/bizz84/starter_architecture_flutter_firebase

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/app_start_and_router/app_start_notifier.dart';
import 'app_start_error_widget.dart';
import 'app_start_loading_widget.dart';

class AppStartWidget extends ConsumerWidget {
  const AppStartWidget({super.key, required this.onLoaded});

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartState = ref.watch(appStartNotifierProvider);
    return appStartState.when(
        loading: () => const AppStartLoadingWidget(),
        error: (e, st) {
          return AppStartErrorWidget(
            message: '${Localize.of(context).appInitialisationError} $e',
            // 'Could not load any data. Please check your internet connection.',
            onRetry: () async {
              await ref.read(appStartNotifierProvider.notifier).retry();
            },
          );
        },
        data: (_) {
          //see goRouterProvider
          return onLoaded(context);
        });
  }
}
