import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';

class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();

  static Future<String?> show(BuildContext context) async {
    var pin = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const PinDialog(),
    );

    return pin;
  }
}

class _PinDialogState extends State<PinDialog> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(Localize.of(context).enterBgPassword),
      ),
      content: CupertinoTextField(
        placeholder: Localize.of(context).enterBgPassword,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        onSubmitted: (value) {
          Navigator.of(context, rootNavigator: true).pop(value);
        },
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(Localize.of(context).cancel),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: password.isNotEmpty
              ? () {
                  Navigator.of(context, rootNavigator: true).pop(password);
                }
              : null,
          child: Text(Localize.of(context).submit),
        ),
      ],
    );
  }
}
