import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/app_start_and_router/go_router.dart';

class HiddenAdminButton extends StatefulWidget {
  const HiddenAdminButton({required this.child, super.key});

  final Widget child;

  @override
  State<HiddenAdminButton> createState() => _HiddenAdminButtonState();
}

class _HiddenAdminButtonState extends State<HiddenAdminButton> {
  int tap = 0;
  Timer? _timeout;

  void onTap() async {
    if (kIsWeb) return;
    _timeout?.cancel();
    tap++;
    if (tap >= 6) {
      tap = 0;
      if (!kIsWeb) {
        await context.pushNamed(AppRoute.adminLogin.name);
      }
      await Future.delayed(Duration(seconds: 5));
    } else {
      _timeout = Timer(const Duration(milliseconds: 1500), _resetTaps);
    }
  }

  void _resetTaps() {
    tap = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (d) {
        onTap();
      },
      child: widget.child,
    );
  }
}
