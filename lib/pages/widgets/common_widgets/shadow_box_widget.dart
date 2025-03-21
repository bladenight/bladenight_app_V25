import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShadowBoxWidget extends ConsumerWidget {
  const ShadowBoxWidget(
      {super.key,
      required this.child,
      this.borderRadius = 15,
      this.boxShadowColor = const Color(0xFFFFD700),
      this.offset = const Offset(1.1, 1.1),
      this.edgeInset =
          const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)});

  final double borderRadius;
  final Color boxShadowColor;
  final Widget child;
  final Offset offset;
  final EdgeInsetsGeometry edgeInset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: edgeInset,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).barBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: boxShadowColor,
                offset: offset,
                blurRadius: borderRadius),
          ],
        ),
        child: child,
      ),
    );
  }
}
