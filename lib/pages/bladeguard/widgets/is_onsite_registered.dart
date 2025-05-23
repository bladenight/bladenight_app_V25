import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/file_name_helper.dart';
import '../../../providers/rest_api/onsite_state_provider.dart';
import '../../widgets/buttons/tinted_cupertino_button.dart';
import '../../widgets/common_widgets/shadow_box_widget.dart';
import 'onsite_counter.dart';

class IsOnsiteRegistered extends ConsumerStatefulWidget {
  const IsOnsiteRegistered({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  ConsumerState<IsOnsiteRegistered> createState() => _IsOnsiteRegisteredState();
}

class _IsOnsiteRegisteredState extends ConsumerState<IsOnsiteRegistered>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;
  late final Animation<Color?> _colorAnimation;
  static const imageName = 'assets/images/bladeGuard/bg_onsite_true.png';

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
    _colorAnimation = ColorTween(
      begin: CupertinoColors.systemGreen, //(0x00ffffff),
      end: Colors.greenAccent, // ,Color(0x00ffff00),
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
        animation: _colorAnimation,
        builder: (context, child) {
          return ShadowBoxWidget(
            boxShadowColor: _colorAnimation.value ?? Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 5,
                bottom: 5,
              ),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          Localize.of(context).bgTodayIsRegistered,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        OnsiteCounter(),
                        SizedTintedCupertinoButton(
                          color: Colors.redAccent,
                          onPressed: () async {
                            await QuickAlert.show(
                                context: context,
                                showCancelBtn: true,
                                type: QuickAlertType.confirm,
                                title: Localize.of(context).requestOffSiteTitle,
                                text: Localize.of(context).requestOffSite,
                                confirmBtnText: Localize.of(context).todayNo,
                                cancelBtnText: Localize.of(context).cancel,
                                onConfirmBtnTap: () {
                                  ref
                                      .read(bgIsOnSiteProvider.notifier)
                                      .setOnSiteState(false);
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                });
                          },
                          child: Text(
                            Localize.of(context).bgTodayTapToUnRegister,
                            style: TextStyle(
                              color: CupertinoTheme.brightnessOf(context) ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
              ]),
            ),
          );
        });
  }
}
