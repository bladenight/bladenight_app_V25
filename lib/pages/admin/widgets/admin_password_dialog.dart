import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/cupertino.dart';

import '../../../app_settings/globals.dart';
import '../../../generated/l10n.dart';
import '../../../helpers/deviceid_helper.dart';
import '../../../models/messages/admin.dart';
import '../../../wamp/admin_calls.dart';
import '../../../wamp/wamp_error.dart';
import '../admin_page.dart';

const kInvalidPassword = 'http://app.bladenight/invalidPassword';

class AdminPasswordDialog extends StatefulWidget {
  const AdminPasswordDialog({Key? key}) : super(key: key);

  @override
  State<AdminPasswordDialog> createState() => _AdminPasswordDialogState();

  static Future<void> show(BuildContext context) async {
    String? password;
    if (Globals.adminPass == null) {
      password = await showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const AdminPasswordDialog(),
      );
    } else {
      password = Globals.adminPass;
    }

    if (password != null) {
      try {
        //Add loading indicator
        var res = await AdminCalls.verifyAdminPassword(MapperContainer.globals.toMap(
            AdminMessage.authenticate(
                password: password, deviceId: await DeviceId.getId)));

        if (res != 'OK') {
          throw WampError(kInvalidPassword);
        }
      } on WampError catch (e) {
        if (e.message == kInvalidPassword) {
          print('INVALID PASSWORD');
          Globals.adminPass = null;
          return;
        } else {
          rethrow;
        }
      }
      Globals.adminPass = password;
      await Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => AdminPage(password: password!),
      ));
    }
  }
}

class _AdminPasswordDialogState extends State<AdminPasswordDialog> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text('Enter password'),
      ),
      content: CupertinoTextField(
        placeholder: 'Admin Password',
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
