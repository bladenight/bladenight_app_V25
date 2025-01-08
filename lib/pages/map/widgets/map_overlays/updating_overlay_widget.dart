import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class UpdatingOverlayWidget extends StatelessWidget {
  const UpdatingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 15,
      right: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CupertinoTheme.of(context).primaryColor,
            width: 1.0,
          ),
        ),
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(Localize.of(context).updating),
            ),
          ),
          CircularProgressIndicator(
            color: CupertinoTheme.of(context).primaryColor,
          ),
        ]),
      ),
    );
  }
}
