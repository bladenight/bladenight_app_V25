import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/l10n.dart';

class InputNumberDialog extends StatefulWidget {
  const InputNumberDialog(this.title,
      {this.initialValue = 180, this.maxInputLength = 5, super.key});

  final int initialValue;
  final int maxInputLength;
  final String title;

  @override
  State<InputNumberDialog> createState() => _InputNumberDialogState();

  static Future<int?> show(BuildContext context, String title,
      {initialValue = 180}) async {
    var resultNumber = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => InputNumberDialog(
        title,
        initialValue: initialValue,
      ),
    );
    return resultNumber;
  }
}

class _InputNumberDialogState extends State<InputNumberDialog> {
  int? value = 180;
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
        placeholder: '180',
        controller: _textEditingController,
        autocorrect: false,
        maxLength: widget.maxInputLength,
        onChanged: (val) {
          setState(() {
            value = int.tryParse(val) ?? 180;
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
          onPressed:
              value != null && value! > 0 ? () => context.pop(value) : null,
          child: Text(Localize.of(context).ok),
        ),
      ],
    );
  }
}
