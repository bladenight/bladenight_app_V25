import 'package:flutter/cupertino.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';

/// Widget while initialization is in progress
class AppStartLoadingWidget extends StatelessWidget {
  const AppStartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CupertinoActivityIndicator(),
          Image.asset(
            'assets/images/2025_SKM_Wappen_Logo.png',
            width: MediaQuery.sizeOf(context).height * 0.3,
          ),
          ColoredBox(
            color: CupertinoTheme.brightnessOf(context) == Brightness.light
                ? systemPrimaryDarkDefaultColor
                : systemPrimaryDefaultColor,
            child: Text(
              Localize.of(context).loading,
              style: TextStyle(
                color: CupertinoTheme.brightnessOf(context) == Brightness.light
                    ? systemPrimaryDefaultColor
                    : systemPrimaryDarkDefaultColor,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
