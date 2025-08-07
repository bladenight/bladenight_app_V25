import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class MultiExpandablePositionedButton extends ConsumerStatefulWidget {
  MultiExpandablePositionedButton(
      {super.key,
      required this.children,
      required this.onPressed,
      required this.tooltip,
      this.iconData})
      //given condition is true and throw if the condition evaluates to false
      : assert(children.isNotEmpty, "Children list can't be empty"),
        super();

  final List<MultiButton> children;
  final Function() onPressed;
  final String tooltip;
  final AnimatedIconData? iconData;

  @override
  ConsumerState<MultiExpandablePositionedButton> createState() =>
      _MultiExpandablePositionedButtonState();
}

class _MultiExpandablePositionedButtonState
    extends ConsumerState<MultiExpandablePositionedButton>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget get _toggleWidget {
    return FloatingActionButton(
      backgroundColor: ColorTween(
        begin: CupertinoTheme.of(context).primaryColor,
        end: Colors.red,
      )
          .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.00,
              1.00,
              curve: Curves.linear,
            ),
          ))
          .value,
      foregroundColor: isOpened
          ? Colors.black
          : CupertinoTheme.of(context).barBackgroundColor,
      onPressed: animate,
      tooltip: Localize.of(context).menu,
      child: AnimatedIcon(
        icon: widget.iconData ?? AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) {
        if (isOpened) animate();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          for (int i = widget.children.length; i >= 1; i--)
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * i,
                0.0,
              ),
              child: FloatingActionButton.extended(
                heroTag: widget.children[i - 1].heroTag,
                label: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: isOpened
                      ? Text(widget.children[i - 1].labelText)
                      : const SizedBox(),
                ),
                onPressed: () async {
                  widget.children[i - 1].onPressed?.call();
                  if (isOpened) {
                    animate();
                  }
                },
                icon: widget.children[i - 1].icon,
                extendedIconLabelSpacing: isOpened ? 10 : 0,
                extendedPadding: isOpened ? null : const EdgeInsets.all(16),
              ),
            ),
          _toggleWidget,
        ],
      ),
    );
  }
}

class MultiButton {
  MultiButton(
      {required this.heroTag,
      required this.labelText,
      required this.icon,
      required this.onPressed});

  final String heroTag;
  final String labelText;
  final VoidCallback? onPressed;
  final Widget? icon;
}
