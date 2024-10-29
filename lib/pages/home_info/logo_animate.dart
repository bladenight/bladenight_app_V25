import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../app_settings/app_configuration_helper.dart';

class LogoAnimate extends StatefulWidget {
  const LogoAnimate(
    this.animationController, {
    super.key,
  });

  final AnimationController animationController;

  @override
  State<LogoAnimate> createState() => _LogoAnimateState();
}

class _LogoAnimateState extends State<LogoAnimate> {
  late Timer _switchingTimer;

  bool _firstChild = false;

  @override
  void initState() {
    super.initState();
    _switchingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _firstChild = !_firstChild;
      });
    });
  }

  @override
  void dispose() {
    widget.animationController.dispose();
    _switchingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Image.asset(bnLogoPlaceholder, fit: BoxFit.contain),
      secondChild: Image.asset(
        skmLogoPlaceholder,
        fit: BoxFit.contain,
      ),
      crossFadeState:
          _firstChild ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(seconds: 3),
    );
  }
}
