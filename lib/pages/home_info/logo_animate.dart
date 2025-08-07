import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../app_settings/app_configuration_helper.dart';

class LogoAnimate extends StatefulWidget {
  const LogoAnimate({
    super.key,
  });

  @override
  State<LogoAnimate> createState() => _LogoAnimateState();
}

class _LogoAnimateState extends State<LogoAnimate>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Timer _switchingTimer;

  bool _firstChild = false;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _switchingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        setState(() {
          _firstChild = !_firstChild;
        });
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _switchingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Image.asset(emptySponsorPlaceholder, fit: BoxFit.contain),
      secondChild: Image.asset(
        skmLogoPlaceholder,
        fit: BoxFit.contain,
      ),
      crossFadeState:
          _firstChild ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 500),
    );
  }
}
