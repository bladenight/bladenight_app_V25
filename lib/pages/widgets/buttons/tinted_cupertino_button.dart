import 'package:flutter/cupertino.dart';

class TintedCupertinoButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CupertinoButton.tinted(
        sizeStyle: CupertinoButtonSize.small,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color ?? CupertinoTheme.of(context).primaryContrastingColor,
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: child);
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
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width ?? MediaQuery.sizeOf(context).width * 0.9,
        child: super.build(context));
  }
}
