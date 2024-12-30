import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../models/friend.dart';
import '../../../providers/friends_provider.dart';
import '../../widgets/bottom_sheets/base_bottom_sheet_widget.dart';
import '../../widgets/common_widgets/tinted_cupertino_button.dart';

class FriendsActionModal extends ConsumerWidget {
  const FriendsActionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: kIsWeb
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.5,
      ),
      child: BaseBottomSheetWidget(children: [
        CupertinoFormSection(
            header: Text(Localize.of(context).addFriendWithCodeHeader),
            children: [
              SizedTintedCupertinoButton(
                child: Row(children: [
                  const Icon(Icons.add_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Localize.of(context).addnewfriend),
                  ),
                ]),
                onPressed: () {
                  Navigator.of(context).pop(FriendsAction.addNew);
                },
              ),
              CupertinoFormSection(
                  header: Text(Localize.of(context).addNewFriendHeader),
                  children: [
                    SizedTintedCupertinoButton(
                      child: Row(children: [
                        const Icon(Icons.pin),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(Localize.of(context).addfriendwithcode),
                        ),
                      ]),
                      onPressed: () {
                        Navigator.of(context).pop(FriendsAction.addWithCode);
                      },
                    ),
                  ]),
            ]),
        CupertinoFormSection(
            header: Text(Localize.of(context).refreshHeader),
            children: [
              SizedTintedCupertinoButton(
                child: Row(children: [
                  const Icon(Icons.update),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Localize.of(context).refresh),
                  ),
                ]),
                onPressed: () async {
                  await ref.read(friendsLogicProvider).refreshFriends();
                  if (!context.mounted || !Navigator.canPop(context)) {
                    return;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ]),
      ]),
    );
  }
}
