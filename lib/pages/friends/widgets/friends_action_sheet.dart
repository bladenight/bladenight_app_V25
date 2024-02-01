import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

enum FriendsAction {
  addNew,
  addWithCode,
  addNearby,
  acceptNearby,
  edit,
  delete
}

class FriendsActionModal extends StatelessWidget {
  const FriendsActionModal({super.key});

  static Future<FriendsAction?> show(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => const FriendsActionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).addNearBy),
          onPressed: () {
            Navigator.pop(context, FriendsAction.addNearby);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).linkNearBy),
          onPressed: () {
            Navigator.pop(context, FriendsAction.acceptNearby);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).addnewfriend),
          onPressed: () {
            Navigator.pop(context, FriendsAction.addNew);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(Localize.of(context).addfriendwithcode),
          onPressed: () {
            Navigator.pop(context, FriendsAction.addWithCode);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(Localize.of(context).cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
