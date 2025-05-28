import 'dart:async';
import 'dart:convert' show HtmlEscape;

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import 'app_start_widget.dart';

class AppRootWidget extends ConsumerStatefulWidget {
  const AppRootWidget({super.key});

  @override
  ConsumerState<AppRootWidget> createState() => _AppRootWidget();
}

class _AppRootWidget extends ConsumerState<AppRootWidget> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    //problem with some sw releases and bad encoded uri
    var fullText = uri.toString();
    var unescaped = Uri.decodeFull(fullText);
    var encodedUri = Uri.tryParse(unescaped);
    if (encodedUri == null) return;
    ref
        .read(goRouterProvider)
        .push(encodedUri.path, extra: encodedUri.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    //no localize if routerProvider deep linked
    final goRouter = ref.watch(goRouterProvider);
    return CupertinoApp.router(
      routerConfig: goRouter,
      supportedLocales: Localize.delegate.supportedLocales,
      title: 'BladeNightApp',
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
