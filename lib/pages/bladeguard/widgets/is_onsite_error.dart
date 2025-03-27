import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/file_name_helper.dart';
import '../../../providers/rest_api/onsite_state_provider.dart';
import '../../widgets/buttons/tinted_cupertino_button.dart';
import '../../widgets/common_widgets/shadow_box_widget.dart';

class IsOnsiteError extends ConsumerStatefulWidget {
  const IsOnsiteError(
      {super.key, required this.error, this.animationController});

  final AnimationController? animationController;
  final String error;

  @override
  ConsumerState<IsOnsiteError> createState() => _IsOnsiteErrorState();
}

class _IsOnsiteErrorState extends ConsumerState<IsOnsiteError>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;
  late final Animation<Color?> _colorAnimation;

  static const imageName = 'assets/images/bladeGuard/bg_onsite_no_network.png';

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
      begin: CupertinoColors.systemRed, //(0x00ffffff),
      end: CupertinoColors.systemOrange, // ,Color(0x00ffff00),
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
              child: CupertinoButton(
                padding: const EdgeInsets.all(10.0),
                onPressed: () async {
                  ref.invalidate(bgIsOnSiteProvider);
                },
                color: CupertinoTheme.of(context).barBackgroundColor,
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Row(children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            Localize.of(context).warning,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedTintedCupertinoButton(
                            color: Colors.red,
                            onPressed: () {
                              ref.invalidate(bgIsOnSiteProvider);
                            },
                            child: Text(
                              widget.error,
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
            ),
          );
        });
  }
}
