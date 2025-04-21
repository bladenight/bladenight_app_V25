import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';

/// Widget while initialization is in progress
class AppStartLoadingWidget extends StatelessWidget {
  const AppStartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          LinearProgressIndicator(
            color: CupertinoTheme.of(context).primaryColor,
          ),
          Image.asset(
            kIsWeb
                ? 'images/app_logo/skm_bn_child__red_1152x2_android.png'
                : 'assets/images/app_logo/skm_bn_child__red_1152x2_android.png',
            width: MediaQuery.sizeOf(context).height * 0.3,
          ),
          ColoredBox(
            color: Colors.black,
            child: Text(
              Localize.of(context).loading,
              style: TextStyle(
                color: CupertinoTheme.of(context).primaryColor,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
