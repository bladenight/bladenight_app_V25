import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../generated/l10n.dart';
import '../../helpers/device_info_helper.dart';
import '../../helpers/notification/toast_notification.dart';

class SendMailWidget extends StatelessWidget {
  const SendMailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Text(Localize.of(context).sendMail),
        onPressed: () async {
          await _sendMail();
        });
  }
}

_sendMail() async {
  try {
    var aV = await DeviceHelper.getAppVersionsData();
    final Email email = Email(
      subject:
          'Bladenight München Anfrage (App V${aV.version} build${aV.buildNumber})',
      body: 'Ich möchte ...:\n',
      recipients: ['it@huth.app'],
      cc: ['service@skatemunich.de'],
      //bcc: ['bcc@example.com'],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  } catch (e) {
    showToast(message: Localize.current.failed);
  }
}
