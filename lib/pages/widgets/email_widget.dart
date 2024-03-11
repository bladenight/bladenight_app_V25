import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';
import '../../helpers/validator.dart';
import '../../providers/settings/bladeguard_provider.dart';

class EmailTextField extends ConsumerStatefulWidget {
  const EmailTextField({super.key});

  @override
  ConsumerState<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends ConsumerState<EmailTextField> {
  final TextEditingController _emailTextController = TextEditingController();
  bool validEmail = true;

  @override
  void initState() {
    _emailTextController.text = HiveSettingsDB.bladeguardEmail ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      header: Text(Localize.current.enterEmail),
      children: <Widget>[
        CupertinoTextFormFieldRow(
          controller: _emailTextController,
          placeholder: Localize.of(context).enterEmail,
          autocorrect: false,
          prefix: ref.watch(isValidBladeGuardEmailProvider)
              ? const Icon(CupertinoIcons.hand_thumbsup, color: Colors.green)
              : const Icon(CupertinoIcons.hand_thumbsdown, color: Colors.red),
          maxLines: 1,
          onChanged: (value) {
            var validEmail = validateEmail(_emailTextController.text);
            if (validEmail || _emailTextController.text == '') {
              HiveSettingsDB.setBladeguardEmail(_emailTextController.text);
            }
            setState(() {});
          },
          onFieldSubmitted: (value) {
            _emailTextController.text;
          },
        ),
      ],
    );
  }
}
