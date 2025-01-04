import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_settings/app_configuration_helper.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/url_launch_helper.dart';
import '../../../providers/app_outdated_provider.dart';
import '../animated/alert_animated_widget.dart';

class AppOutdated extends ConsumerStatefulWidget {
  const AppOutdated({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  ConsumerState<AppOutdated> createState() => _AppOutdatedState();
}

class _AppOutdatedState extends ConsumerState<AppOutdated> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    var pr = ref.watch(appOutdatedProvider);
    if (!pr) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            Launch.launchUrlFromString(playStoreLink,
                mode: LaunchMode.platformDefault);
          }
          if (Platform.isIOS) {
            Launch.launchUrlFromString(iOSAppStoreLink,
                mode: LaunchMode.platformDefault);
          }
        },
        child: AlertAnimated(
          animationController: widget.animationController,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    Localize.of(context).appOutDated,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
