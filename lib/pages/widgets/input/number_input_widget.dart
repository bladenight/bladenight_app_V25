import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberInputWidget extends ConsumerStatefulWidget {
  const NumberInputWidget({
    super.key,
    required this.header,
    required this.code,
    required this.onChanged,
    this.placeholder = '',
    this.minLength = 6,
    this.maxLength = 6,
    this.requestFocus = false,
  });

  final String header;
  final String code;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final int minLength;
  final int maxLength;
  final bool requestFocus;

  @override
  ConsumerState<NumberInputWidget> createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends ConsumerState<NumberInputWidget> {
  static TextEditingController? _inputTextController;
  bool validNumber = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController(text: widget.code);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.requestFocus) _focusNode.requestFocus();
      setState(() {
        validNumber = _inputTextController!.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusNode.dispose();
    _inputTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      header: Text(widget.header),
      children: <Widget>[
        CupertinoTextFormFieldRow(
          controller: _inputTextController,
          focusNode: _focusNode,
          placeholder: widget.placeholder,
          autocorrect: false,
          keyboardType: TextInputType.number,
          prefix: validNumber
              ? const Icon(CupertinoIcons.hand_thumbsup, color: Colors.green)
              : const Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red),
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              var isNumber = int.tryParse(value);
              validNumber = value.length >= widget.minLength &&
                  value.length <= widget.maxLength &&
                  isNumber != null;
              widget.onChanged!(value);
            });
          },
          decoration: BoxDecoration(
            border: Border.all(
              color: validNumber
                  ? CupertinoAdaptiveTheme.of(context).theme.brightness ==
                          Brightness.light
                      ? CupertinoColors.black
                      : CupertinoColors.white
                  : Colors.red,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}
