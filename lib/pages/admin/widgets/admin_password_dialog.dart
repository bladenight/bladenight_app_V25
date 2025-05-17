import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../providers/admin/admin_pwd_provider.dart';
import '../../../providers/app_start_and_router/go_router.dart';
import '../../../providers/network_connection_provider.dart';
import '../../widgets/common_widgets/no_connection_warning.dart';

const kInvalidPassword = 'http://app.bladenight/invalidPassword';

class AdminPasswordDialog extends ConsumerStatefulWidget {
  const AdminPasswordDialog({super.key});

  @override
  ConsumerState<AdminPasswordDialog> createState() =>
      _AdminPasswordDialogState();
}

class _AdminPasswordDialogState extends ConsumerState<AdminPasswordDialog> {
  String password = '';
  bool isLoading = false;
  var counter = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var network = ref.watch(networkAwareProvider);
    if (network.connectivityStatus != ConnectivityStatus.wampConnected) {
      return GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          }
        },
        child: SizedBox(
          height: 30,
          child: ConnectionWarning(),
        ),
      );
    }
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(Localize.of(context).enterPassword),
      ),
      content: isLoading
          ? CupertinoActivityIndicator()
          : CupertinoTextField(
              placeholder: Localize.of(context).enterPassword,
              obscureText: true,
              obscuringCharacter: '*',
              autocorrect: false,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (value) {
                if (context.canPop()) {
                  context.pop();
                }
                //Navigator.of(context, rootNavigator: true).pop(value);
              },
            ),
      actions: [
        CupertinoDialogAction(
          child: Text(Localize.of(context).cancel),
          onPressed: () {
            context.pop();
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: password.isNotEmpty
              ? () async {
                  setState(() {
                    isLoading = true;
                  });
                  var res = await ref
                      .read(adminPasswordCheckProvider.notifier)
                      .login(password);
                  setState(() {
                    isLoading = false;
                  });
                  if (res && context.mounted) {
                    context.goNamed(AppRoute.adminPage.name);
                  }
                }
              : null,
          child: Text(Localize.of(context).submit),
        ),
      ],
    );
  }
}
