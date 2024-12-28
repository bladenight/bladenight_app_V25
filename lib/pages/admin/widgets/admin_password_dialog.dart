import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/deviceid_helper.dart';
import '../../../helpers/hive_box/hive_settings_db.dart';
import '../../../helpers/logger.dart';
import '../../../helpers/wamp/exceptions/bad_result_exception.dart';
import '../../../models/messages/admin.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../../wamp/admin_calls.dart';

const kInvalidPassword = 'http://app.bladenight/invalidPassword';

class AdminPasswordDialog extends StatefulWidget {
  const AdminPasswordDialog({super.key});

  @override
  State<AdminPasswordDialog> createState() => _AdminPasswordDialogState();

  static Future<void> show(BuildContext context) async {
    String? password;
    if (HiveSettingsDB.serverPassword == null) {
      password = await showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const AdminPasswordDialog(),
      );
    } else {
      password = HiveSettingsDB.serverPassword;
    }

    if (password != null) {
      try {
        //Add loading indicator
        var res = await AdminCalls.verifyAdminPassword(MapperContainer.globals
            .toMap(AdminMessage.authenticate(
                password: password, deviceId: DeviceId.appId)));

        if (res != 'OK') {
          throw BadResultException(kInvalidPassword);
        }
      } on BadResultException catch (e) {
        if (e.reason == kInvalidPassword) {
          BnLog.warning(text: 'Admin has sent an invalid password');
          HiveSettingsDB.setServerPassword(null);
          return;
        } else {
          rethrow;
        }
      }
      HiveSettingsDB.setServerPassword(password);
      if (!context.mounted) return;
      await context.pushNamed(AppRoute.adminPage.name,
          pathParameters: {'password': password});
    }
  }
}

class _AdminPasswordDialogState extends State<AdminPasswordDialog> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(Localize.of(context).enterPassword),
      ),
      content: CupertinoTextField(
        placeholder: Localize.of(context).enterPassword,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        onSubmitted: (value) {
          context.pop(value);
        },
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(Localize.of(context).cancel),
          onPressed: () {
            context.pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: password.isNotEmpty
              ? () {
                  context.pop(password);
                }
              : null,
          child: Text(Localize.of(context).submit),
        ),
      ],
    );
  }
}
