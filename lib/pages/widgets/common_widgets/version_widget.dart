import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../../../generated/l10n.dart';
import '../../../providers/server_version_provider.dart';
import '../../../providers/version_provider.dart';

class VersionWidget extends ConsumerWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appInfo = ref.watch(versionProvider);
    var serverVersion = ref.watch(serverVersionProvider);
    return appInfo.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Container(),
      data: (appInfoData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Localize.of(context).about_h_version,
                style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
            Container(
              child: Platform.isAndroid || kIsWeb
                  ? Text(
                      '${appInfoData.version} (build:${appInfoData.buildNumber})',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle)
                  : Text(
                      '${appInfoData.version} (build:${appInfoData.buildNumber})',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle),
            ),
            SizedBox(
              height: 3,
            ),
            Text(Localize.of(context).serverVersion,
                style: CupertinoTheme.of(context).textTheme.navActionTextStyle),
            Text(serverVersion,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
            Divider(
              height: 1,
            ),
          ],
        );
      },
    );
  }
}
