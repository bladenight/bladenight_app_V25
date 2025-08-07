import 'package:flutter/cupertino.dart';

class DataWaitingIndicator extends StatelessWidget {
  const DataWaitingIndicator({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
        ),
      ],
    );
  }
}
