import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../../generated/l10n.dart';
import 'overlay_clipper.dart';

class TrackOnlyOverlayWidget extends StatelessWidget {
  const TrackOnlyOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
        child: ClipPath(
          clipper: InfoClipper2(),
          child: Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Builder(builder: (context) {
                return Container(
                  color: kIsWeb
                      ? CupertinoTheme.of(context).barBackgroundColor
                      : CupertinoDynamicColor.resolve(
                          CupertinoColors.transparent, context),
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Column(children: [
                      Text(
                        Localize.of(context).onlyTracking,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle,
                      ),
                    ]),
                  ),
                );
              }),
            ),
          ]),
        ),
      ),
    ]);
  }
}
