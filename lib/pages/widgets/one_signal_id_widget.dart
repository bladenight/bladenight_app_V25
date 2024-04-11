import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../providers/onesignal_provider.dart';

class OneSignalIdWidget extends ConsumerWidget {
  const OneSignalIdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var oneSignalInfoData = ref.watch(onesignalIdProvider);
    return oneSignalInfoData.when(
        loading: () => Container(),
        error: (err, stack) => Text(Localize.of(context).failed),
        data: (id) => id != null && HiveSettingsDB.pushNotificationsEnabled
            ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CupertinoFormSection(
                    header: Text(Localize.of(context).oneSignalIdTitle),
                    children: <Widget>[
                      CupertinoButton(
                          child: Text(
                              '${Localize.of(context).oneSignalId}\n$id',
                              textAlign: TextAlign.center),
                          onPressed: () {
                            if (id != '') {
                              Share.share(id);
                            }
                          })
                    ]),
              ])
            : Container());
  }
}
