import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_settings/app_configuration_helper.dart';
import '../../generated/l10n.dart';
import '../../helpers/url_launch_helper.dart';
import '../../providers/app_outdated_provider.dart';

class AppOutdatedWidget extends ConsumerWidget {
  const AppOutdatedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pr = context.watch(appOutdatedProvider);
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 1, 15, 1),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemRed,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    Localize.of(context).appOutDated,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }
  }
}
