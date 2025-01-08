import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/file_name_helper.dart';
import '../../../helpers/time_converter_helper.dart';
import '../../../models/event.dart';
import '../../widgets/common_widgets/shadow_box_widget.dart';

class Wait3Hours extends ConsumerStatefulWidget {
  const Wait3Hours({required this.event, super.key, this.animationController});

  final AnimationController? animationController;
  final Event event;

  @override
  ConsumerState<Wait3Hours> createState() => _Wait3HoursState();
}

class _Wait3HoursState extends ConsumerState<Wait3Hours>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;
  late final Animation<Color?> _colorAnimationYellow;
  static const imageName = 'assets/images/bladeGuard/bg_onsite_timer.png';

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
    _colorAnimationYellow = ColorTween(
      begin: CupertinoColors.systemYellow, //(0x00ffffff),
      end: CupertinoColors.systemGrey, // ,Color(0x00ffff00),
    ).animate(_animationController!);
    _animationController!.repeat(reverse: true);
    _animationController!.addListener(() {
      //print('aniCtrVal=${_animationController!.value}');
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorAnimationYellow,
        builder: (context, child) {
          return ShadowBoxWidget(
            boxShadowColor: _colorAnimationYellow.value ?? Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 5,
                bottom: 5,
              ),
              child: Row(children: [
                Expanded(
                  child: Expanded(
                    child: Column(children: [
                      Text(
                        Localize.of(context).loginThreeHoursBefore,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (!widget.event.isActive &&
                          widget.event.status == EventStatus.confirmed)
                        AnimatedBuilder(
                            animation: _colorAnimationYellow,
                            builder: (context, child) {
                              return Text(
                                '${Localize.of(context).start} in ${TimeConverter.millisecondsToDateTimeString(value: widget.event.startDate.difference(DateTime.now()).inMilliseconds)}',
                                textAlign: TextAlign.center,
                              );
                            }),
                    ]),
                  ),
                ),
                Image.asset(
                  CupertinoTheme.brightnessOf(context) == Brightness.light
                      ? getDarkName(imageName)
                      : imageName,
                  width: MediaQuery.sizeOf(context).height * 0.1,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),
              ]),
            ),
          );
        });
  }
}
