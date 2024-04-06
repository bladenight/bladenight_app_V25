import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

class OneSignalIdWidget extends ConsumerWidget {
  const OneSignalIdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var oneSignalInfoData = HiveSettingsDB.oneSignalId;
    return oneSignalInfoData.isNotEmpty && HiveSettingsDB.pushNotificationsEnabled
        ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CupertinoFormSection(
                header: Text(Localize.of(context).oneSignalIdTitle),
                children: <Widget>[
                  CupertinoButton(
                      child: Text(
                          '${Localize.of(context).oneSignalId}\n$oneSignalInfoData',
                          textAlign: TextAlign.center),
                      onPressed: () {
                        if (oneSignalInfoData != '') {
                          Share.share(oneSignalInfoData);
                        }
                      })
                ]),
          ])
        : Container();
  }
}
