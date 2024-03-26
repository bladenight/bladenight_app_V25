import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/deviceid_helper.dart';

class AppIdWidget extends ConsumerWidget {
  const AppIdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      CupertinoFormSection(
          header: Text(Localize.of(context).appIdTitle),
          children: <Widget>[
            CupertinoButton(
                child: Text('${Localize.of(context).appId} ${DeviceId.appId}'),
                onPressed: () => {}),
          ])
    ]);
  }
}
