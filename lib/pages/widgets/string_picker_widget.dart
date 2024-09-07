import 'package:flutter/cupertino.dart';

import 'grip_bar.dart';

class StringPicker extends StatefulWidget {
  final List<String> items;
  final int selectedItem;
  final ValueSetter<int> onSelectedItemChanged;
  final String title;

  const StringPicker({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelectedItemChanged,
  });

  @override
  State createState() => _StringPickerState();
}

class _StringPickerState extends State<StringPicker> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(children: [
        const GripBar(),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.title,
          ),
        ),
        SizedBox(
          height: 200,
          child: CupertinoPicker(
              backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
              useMagnifier: false,
              scrollController:
                  FixedExtentScrollController(initialItem: widget.selectedItem),
              onSelectedItemChanged: widget.onSelectedItemChanged,
              itemExtent: 50,
              children: [
                for (var i in widget.items) Center(child: Text(i.toString()))
              ]),
        ),
      ]),
    );
  }
}
