import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/version_provider.dart';
import 'data_loading_indicator.dart';

class VersionWidget extends ConsumerWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appInfo = ref.watch(versionProvider);
    return appInfo.when(
      loading: () => const DataLoadingIndicator(),
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
                  ? Text(appInfoData.version,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle)
                  : Text(
                      '${appInfoData.version} (build:${appInfoData.buildNumber})',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle),
            ),
          ],
        );
      },
    );
  }
}
