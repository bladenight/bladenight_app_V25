import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import 'app_start_widget.dart';

class AppRootWidget extends ConsumerWidget {
  const AppRootWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //no localize if routerProvider deep linked
    final goRouter = ref.watch(goRouterProvider);
    return CupertinoApp.router(
      //routeInformationParser: goRouter.routeInformationParser,
      //routerDelegate: goRouter.routerDelegate,
      routerConfig: goRouter,
      supportedLocales: Localize.delegate.supportedLocales,
      localizationsDelegates: const [
        Localize.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      builder: (_, child) {
        return AppStartWidget(
          onLoaded: (_) => child!,
        );
      },
    );
  }
}
