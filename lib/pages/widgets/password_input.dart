import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../../generated/l10n.dart';
import '../../app_settings/server_connections.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

class InputPasswordDialog extends StatefulWidget {
  const InputPasswordDialog({Key? key}) : super(key: key);

  @override
  State<InputPasswordDialog> createState() => _InputPasswordDialogState();

  static Future<bool> show(BuildContext context) async {
    String bgPassword = utf8.decode(base64.decode(bladeGuardPassword));
    String bgLeaderPassword = utf8.decode(base64.decode(bladeGuardLeaderPassword));
    var password = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const InputPasswordDialog(),
    );

    if (password==null) return false;
    if (password == bgPassword) {
      HiveSettingsDB.setBgSettingVisible(true);
      return true;
    }
    else if (password == bgLeaderPassword) {
      HiveSettingsDB.setBgLeaderSettingVisible(true);
      return true;
    }
    HiveSettingsDB.setBgSettingVisible(false);
    HiveSettingsDB.setBgLeaderSettingVisible(false);
    return true;
  }
}

class _InputPasswordDialogState extends State<InputPasswordDialog> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text('Enter password'),
      ),
      content: CupertinoTextField(
        placeholder: Localize.of(context).entercode,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        onSubmitted: (value) {
          Navigator.of(context).pop(value);
        },
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(Localize.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: password.isNotEmpty
              ? () {
                  Navigator.of(context).pop(password);
                }
              : null,
          child: Text(Localize.of(context).submit),
        ),
      ],
    );
  }
}
