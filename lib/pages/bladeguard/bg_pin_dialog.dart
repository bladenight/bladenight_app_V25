import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';

const kInvalidPassword = 'http://app.bladenight/invalidPassword';

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
