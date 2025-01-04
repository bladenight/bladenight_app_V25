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

import '../common_widgets/shadow_box_widget.dart';

class NoAlertAnimated extends ConsumerStatefulWidget {
  const NoAlertAnimated(
      {super.key,
      required this.child,
      this.animationController,
      this.borderRadius = 15});

  final Widget child;
  final double borderRadius;
  final AnimationController? animationController;

  @override
  ConsumerState<NoAlertAnimated> createState() => _NoAlertAnimatedState();
}

class _NoAlertAnimatedState extends ConsumerState<NoAlertAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;
  late final Animation<Color?> _colorAnimation;
  late final Animation<double> _shimmerAnimation;

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    if (widget.animationController != null) {
      _animationController = widget.animationController;
    } else {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );
    }

    _colorAnimation = ColorTween(
      begin: CupertinoColors.systemGreen, //(0x00ffffff),
      end: CupertinoColors.systemGrey, // ,Color(0x00ffff00),
    ).animate(_animationController!);
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    if (widget.animationController == null) {
      _animationController!.repeat(reverse: true);
    }
  }

  @override
  dispose() {
    if (widget.animationController == null) {
      _animationController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return ShadowBoxWidget(
            boxShadowColor: CupertinoColors.systemGreen,
            borderRadius: widget.borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
                gradient: LinearGradient(
                    colors: [
                      Color(0x004eed00),
                      Color(0x006aed99),
                      Color(0x004eed00)
                    ],
                    stops: [
                      _shimmerAnimation.value + 0.25,
                      _shimmerAnimation.value + 0.5,
                      _shimmerAnimation.value + 0.75,
                    ],
                    begin: const Alignment(-1, -1),
                    end: Alignment(1, 1),
                    tileMode: TileMode.clamp),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: _colorAnimation.value ?? Color(0x00ed8e00),
                      offset: Offset(1.1, 1.1),
                      blurRadius: widget.borderRadius),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/greenHook.png',
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
                        padding: const EdgeInsets.all(2), child: widget.child),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
