import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

/// Widget to show while initialization is in progress
class AppStartLoadingWidget extends StatelessWidget {
  const AppStartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(children: [
        const Center(
          child: CupertinoActivityIndicator(),
        ),
        ColoredBox(
          color: Color(0x00ff00ff),
          child: Text(Localize.of(context).loading),
        )
      ]),
    );
  }
}
