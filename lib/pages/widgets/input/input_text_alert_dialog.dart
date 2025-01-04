import 'package:flutter/cupertino.dart';
import '../../../../generated/l10n.dart';

class InputTextDialog extends StatefulWidget {
  const InputTextDialog(this.title,
      {this.initialValue = '', this.maxInputLength = 25, super.key});

  final String? initialValue;
  final int maxInputLength;
  final String title;

  @override
  State<InputTextDialog> createState() => _InputTextDialogState();

  static Future<String?> show(BuildContext context, String title,
      {initialValue}) async {
    var resultNumber = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => InputTextDialog(
        title,
        initialValue: initialValue,
      ),
    );
    return resultNumber;
  }
}

class _InputTextDialogState extends State<InputTextDialog> {
  String? value;
  late TextEditingController? _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(
        text:
            widget.initialValue == null ? '' : widget.initialValue.toString());
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(widget.title),
      ),
      content: CupertinoTextField(
        placeholder: 'Startpunkt',
        controller: _textEditingController,
        autocorrect: false,
        maxLength: widget.maxInputLength,
        onChanged: (val) {
          setState(() {
            value = val;
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
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(value),
          child: Text(Localize.of(context).ok),
        ),
      ],
    );
  }
}
