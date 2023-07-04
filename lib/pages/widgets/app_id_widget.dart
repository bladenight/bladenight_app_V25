import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/version_provider.dart';
import 'data_loading_indicator.dart';

class AppIdWidget extends ConsumerWidget {
  const AppIdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appInfo = ref.watch(appIdProvider);
    return appInfo.when(
        loading: () => const DataLoadingIndicator(),
        error: (err, stack) => Container(),
        data: (appInfoData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoFormSection(
                    header:  Text(Localize.of(context).appIdTitle),
                    children: <Widget>[
                      CupertinoButton(
                          child: Text('${Localize.of(context).appId} ${appInfoData.toString()}'),
                          onPressed: () => {}),
                    ])
              ]);
        });
  }
}
