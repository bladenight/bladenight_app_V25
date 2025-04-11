import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/common_widgets/no_connection_warning.dart';

class UpdatingOverlayWidget extends StatelessWidget {
  const UpdatingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 15,
      right: 15,
      child: Column(
        children: [
          Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: kIsWeb
                      ? CupertinoTheme.of(context)
                          .barBackgroundColor
                          .withAlpha(200)
                      : CupertinoDynamicColor.resolve(
                          CupertinoColors.transparent, context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CupertinoTheme.of(context).primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(children: [
                        Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(Localize.of(context).updating),
                            ),
                          ),
                          RefreshProgressIndicator(
                            color: CupertinoTheme.of(context).primaryColor,
                          ),
                        ]),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConnectionWarning(),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
