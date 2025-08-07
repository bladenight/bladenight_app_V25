import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'grip_bar.dart';

class BaseBottomSheetWidget extends ConsumerWidget {
  BaseBottomSheetWidget({required this.children, super.key});

  final List<Widget> children;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          const GripBar(),
          Expanded(
            child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                children: children),
          ),
        ]),
      ),
    );
  }
}
