//This file contains part of shimmer_effect package with following licence
/*
Copyright (c) 2023 Deepak Kumar
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/url_launch_helper.dart';
import '../../providers/app_outdated_provider.dart';
import 'shadow_box_widget.dart';

class AppOutdated extends ConsumerStatefulWidget {
  const AppOutdated({super.key});

  @override
  ConsumerState<AppOutdated> createState() => _AppOutdatedState();
}

class _AppOutdatedState extends ConsumerState<AppOutdated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;
  late final Animation<double> _shimmerAnimation;

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _colorAnimation = ColorTween(
      begin: CupertinoColors.systemRed, //(0x00ffffff),
      end: CupertinoColors.systemGrey, // ,Color(0x00ffff00),
    ).animate(_animationController);
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var borderRadius = 15.0;
    var pr = ref.watch(appOutdatedProvider);
    if (!pr) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            Launch.launchUrlFromString(playStoreLink,
                mode: LaunchMode.platformDefault);
          }
          if (Platform.isIOS) {
            Launch.launchUrlFromString(iOSAppStoreLink,
                mode: LaunchMode.platformDefault);
          }
        },
        child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return ShadowBoxWidget(
                boxShadowColor: CupertinoColors.systemRed,
                borderRadius: borderRadius,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    //color: _colorAnimation.value,
                    gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemRed,
                          CupertinoColors.activeOrange,
                          CupertinoColors.systemRed
                        ],
                        stops: [
                          _shimmerAnimation.value + 0.25,
                          _shimmerAnimation.value + 0.5,
                          _shimmerAnimation.value + 0.75,
                        ],
                        begin: const Alignment(-1, -1),
                        end: Alignment(1, 1),
                        tileMode: TileMode.clamp),

                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: _colorAnimation.value ?? Color(0x00ff0000),
                          offset: Offset(1.1, 1.1),
                          blurRadius: borderRadius),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/warn_256.png',
                        width: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .fontSize ??
                            20,
                        height: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .fontSize ??
                            20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            Localize.of(context).appOutDated,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
