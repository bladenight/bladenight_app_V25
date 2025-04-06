import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../app_settings/app_constants.dart';
import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';
import '../providers/app_start_and_router/go_router.dart';

class BaseAppScaffold extends StatelessWidget {
  const BaseAppScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var themeMode = HiveSettingsDB.adaptiveThemeMode;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic obj) async {
        if (context.canPop()) {
          context.pop();
          return;
        }
        if (!didPop) {
          context.goNamed(AppRoute.map.name);
        }
      },
      child: Builder(
        builder: (builder) => ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: MediaQuery.fromView(
            view: View.of(context),
            child: CupertinoAdaptiveTheme(
              light: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: HiveSettingsDB.themePrimaryLightColor,
                primaryContrastingColor: HiveSettingsDB.themePrimaryLightColor
                    .withValues(alpha: primaryContrastingAlpha),
              ),
              dark: CupertinoThemeData(
                brightness: Brightness.dark,
                primaryColor: HiveSettingsDB.themePrimaryDarkColor,
                primaryContrastingColor: HiveSettingsDB.themePrimaryDarkColor
                    .withValues(alpha: primaryContrastingAlpha),
              ),
              initial: themeMode,
              builder: (theme) => CupertinoApp(
                  localizationsDelegates: const [
                    //AppLocalizations.delegate,
                    Localize.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate
                  ],
                  supportedLocales: Localize.delegate.supportedLocales,
                  title: 'BladeNight',
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  home:
                      child /* Stack(
                    children: [
                      child,
                      localTesting
                          ? SafeArea(
                              child: Text(
                                  'Size w:${round(MediaQuery.sizeOf(context).width, decimals: 0)} h:${round(MediaQuery.sizeOf(context).height, decimals: 0)}'))
                          : Container(),
                    ],
                  ),*/
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
