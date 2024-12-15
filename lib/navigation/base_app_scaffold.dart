import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../generated/l10n.dart';
import '../helpers/hive_box/hive_settings_db.dart';

class BaseAppScaffold extends StatelessWidget {
  const BaseAppScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic obj) async {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(Localize.of(context).closeApp),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(Localize.of(context).yes),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(Localize.of(context).no),
                ),
              ],
            );
          },
        );
        return;
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
                  primaryColor: HiveSettingsDB.themePrimaryLightColor),
              dark: CupertinoThemeData(
                brightness: Brightness.dark,
                primaryColor: HiveSettingsDB.themePrimaryDarkColor,
              ),
              initial: HiveSettingsDB.adaptiveThemeMode,
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
                title: 'BladeNight München',
                debugShowCheckedModeBanner: false,
                theme: theme,
                home: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
