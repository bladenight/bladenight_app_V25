import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../helpers/hive_box/hive_settings_db.dart';

class BirthdayDatePicker extends ConsumerStatefulWidget {
  const BirthdayDatePicker({super.key});

  @override
  ConsumerState<BirthdayDatePicker> createState() => _BirthdayTextFieldState();
}

class _BirthdayTextFieldState extends ConsumerState<BirthdayDatePicker> {
  bool validBirthday = true;
  DateTime date = HiveSettingsDB.bladeguardBirthday;

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      header: Text(Localize.current.enterBirthday),
      children: <Widget>[
        _DatePickerItem(
          children: <Widget>[
            Text(Localize.of(context).birthday),
            CupertinoButton(
              // Display a CupertinoDatePicker in date picker mode.
              onPressed: () async{
                var picked = await showDatePicker(
                context: context,
                  locale: const Locale('de', 'DE'),
                  initialDate: HiveSettingsDB.bladeguardBirthday,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().subtract(const Duration(days:365*16)),

                  );
                if (picked != null){
                  HiveSettingsDB.setBladeguardBirthday(picked);
                  setState(() => date = picked);
                }
              },
              child: Text(
                Localize.of(context).dateIntl(date),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
