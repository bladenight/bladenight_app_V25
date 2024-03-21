import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

class PhoneTextField extends ConsumerStatefulWidget {
  const PhoneTextField({super.key});

  @override
  ConsumerState<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends ConsumerState<PhoneTextField> {
  final TextEditingController _phoneTextController = TextEditingController();
  bool validPhone = true;

  @override
  void initState() {
    _phoneTextController.text = HiveSettingsDB.bladeguardPhone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validPhone = _phoneTextController.text.length > 7;
    return CupertinoFormSection(
      header: Text(Localize.current.enterPhoneNumber),
      children: <Widget>[
        CupertinoTextFormFieldRow(
          controller: _phoneTextController,
          placeholder: Localize.of(context).phoneNumber,
          autocorrect: false,
          prefix: validPhone
              ? const Icon(CupertinoIcons.hand_thumbsup, color: Colors.green)
              : const Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red),
          maxLines: 1,
          onChanged: (value) {
            setState(() {
              RegExp regexp= RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
              var match = regexp.allMatches(_phoneTextController.text);
              validPhone = _phoneTextController.text.length > 7;
            });
            if (validPhone) {
              HiveSettingsDB.setBladeguardPhone(
                  _phoneTextController.text.toLowerCase());
            }
          },
          onFieldSubmitted: (value) {
            _phoneTextController.text;
          },
        ),
      ],
    );
  }
}
