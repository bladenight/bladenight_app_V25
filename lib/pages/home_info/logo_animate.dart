import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../app_settings/app_configuration_helper.dart';

class LogoAnimate extends StatefulWidget {
  const LogoAnimate({super.key});

  @override
  State<LogoAnimate> createState() => _LogoAnimateState();
}

class _LogoAnimateState extends State<LogoAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _switchingTimer;

  bool _firstChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _switchingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _firstChild = !_firstChild;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
