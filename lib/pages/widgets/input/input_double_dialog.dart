import 'package:flutter/cupertino.dart';
import '../../../../generated/l10n.dart';

class InputDoubleDialog extends StatefulWidget {
  const InputDoubleDialog(this.title,
      {this.initialValue = 0.0, this.maxInputLength = 12, super.key});

  final double initialValue;
  final int maxInputLength;
  final String title;

  @override
  State<InputDoubleDialog> createState() => _InputDoubleDialogState();

  static Future<double?> show(BuildContext context, String title,
      {initialValue = 0.0}) async {
    var resultNumber = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => InputDoubleDialog(
        title,
        initialValue: initialValue,
      ),
    );
    return resultNumber;
  }
}

class _InputDoubleDialogState extends State<InputDoubleDialog> {
  double? value = 0.0;
  late TextEditingController? _textEditingController;

  @override
  void initState() {
    _textEditingController =
        TextEditingController(text: widget.initialValue.toString());
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
        placeholder: '0.0',
        controller: _textEditingController,
        autocorrect: false,
        maxLength: widget.maxInputLength,
        onChanged: (val) {
          setState(() {
            value = double.tryParse(val) ?? 0.0;
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
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: value != null
              ? () => Navigator.of(context, rootNavigator: true).pop(value)
              : null,
          child: Text(Localize.of(context).ok),
        ),
      ],
    );
  }
}
