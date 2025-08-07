import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class TextInputWidget extends ConsumerStatefulWidget {
  const TextInputWidget({
    super.key,
    required this.header,
    required this.value,
    required this.onChanged,
    this.placeholder = '',
    this.minLength = 1,
    this.requestFocus = true,
  });

  final String value;
  final String header;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final int minLength;
  final bool requestFocus;

  @override
  ConsumerState<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends ConsumerState<TextInputWidget> {
  TextEditingController? _inputTextController;
  bool validText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.requestFocus) _focusNode.requestFocus();
      setState(() {
        validText = _inputTextController!.text.length >= widget.minLength;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    //_nameFocusNode.dispose();
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
          placeholder: Localize.of(context).enterfriendname,
          autocorrect: false,
          prefix: validText
              ? const Icon(CupertinoIcons.hand_thumbsup, color: Colors.green)
              : const Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red),
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              validText = value.length >= widget.minLength;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          decoration: BoxDecoration(
            border: Border.all(
              color: validText
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
