import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

class DataLoadingIndicator extends StatelessWidget {
  const DataLoadingIndicator({super.key});

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
          Localize.of(context).getwebdata,
          style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
        )
      ],
    );
  }
}
