import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../generated/l10n.dart';
import '../../../helpers/device_info_helper.dart';
import '../../../helpers/notification/toast_notification.dart';

class SendMailWidget extends StatelessWidget {
  const SendMailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: CupertinoButton(
          color: Colors.orange.shade500,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              Localize.of(context).sendMail,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          onPressed: () async {
            await _sendMail();
          }),
    );
  }
}

_sendMail() async {
  try {
    var aV = await DeviceHelper.getAppVersionsData();
    var os = await DeviceHelper.getOSInfo();
    final Email email = Email(
      subject:
          'BladeNight! München Anfrage (App V${aV.version} build${aV.buildNumber} - $os)',
      body: 'Ich habe ein Problem und bitte um Unterstützung:\n',
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
