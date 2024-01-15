import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../pages/admin/widgets/admin_password_dialog.dart';

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
    if(kIsWeb) return;
    _timeout?.cancel();
    tap++;
    if (tap >= 5 && tap <=8) {
      await AdminPasswordDialog.show(context);
      tap = 0;
    } else {
      _timeout = Timer(const Duration(milliseconds: 1500), resetTaps);
    }
  }

  void resetTaps() {
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
