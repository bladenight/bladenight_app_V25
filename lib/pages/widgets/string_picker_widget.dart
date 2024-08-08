import 'package:flutter/cupertino.dart';

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
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController(initialItem: widget.selectedItem);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                color: CupertinoTheme.of(context).barBackgroundColor),
            child: Text(
              widget.title,
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoPicker(
                backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
                useMagnifier: false,
                scrollController: FixedExtentScrollController(initialItem: widget.selectedItem),
                onSelectedItemChanged: widget.onSelectedItemChanged,
                itemExtent: 50,
                children: [
                  for (var i in widget.items) Center(child: Text(i.toString()))
                ]),
          ),
        ],
      ),
    );
  }
}
