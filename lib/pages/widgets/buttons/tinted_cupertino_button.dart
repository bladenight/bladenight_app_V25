import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings/dark_color_provider.dart';
import '../../../providers/settings/light_color_provider.dart';

class TintedCupertinoButton extends ConsumerWidget {
  const TintedCupertinoButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.onLongPress,
      this.color});

  final Widget child;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkCol = ref.watch(themePrimaryDarkColorProvider);
    var lightCol = ref.watch(themePrimaryLightColorProvider);
    var btnCol = CupertinoTheme.of(context).brightness == Brightness.dark
        ? lightCol
        : darkCol;
    return Padding(
      padding: EdgeInsets.all(10),
      child: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: color ?? btnCol,
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: child),
    );
  }
}

/// returns a sized tinted CupertinoButton
///
/// if no [width] given a MediaQuery.sizeOf(context).width * 0.9
/// is set
class SizedTintedCupertinoButton extends TintedCupertinoButton {
  const SizedTintedCupertinoButton({
    super.key,
    required super.child,
    required super.onPressed,
    super.onLongPress,
    super.color,
    this.height,
    this.width,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        height: height,
        width: width ?? MediaQuery.sizeOf(context).width * 0.9,
        child: super.build(context, ref));
  }
}
