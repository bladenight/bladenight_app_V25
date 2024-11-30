import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';
import 'alert_animated_widget.dart';
import 'shadow_box_widget.dart';

class ConnectionWarning extends ConsumerStatefulWidget {
  const ConnectionWarning({super.key, this.reason, this.height = 20});

  final Exception? reason;
  final double height;

  @override
  ConsumerState<ConnectionWarning> createState() => _ConnectionWarning();
}

class _ConnectionWarning extends ConsumerState<ConnectionWarning>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    assert(widget.height > 0 && widget.height >= 20,
        'Widget should be have have height greater 20 or 0');
    var networkAware = ref.watch(networkAwareProvider);
    if (networkAware.connectivityStatus == ConnectivityStatus.error ||
        networkAware.connectivityStatus == ConnectivityStatus.disconnected) {
      return AlertAnimated(
        child: GestureDetector(
          onTap: () => ref.read(networkAwareProvider.notifier).refresh(),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      Localize.of(context).seemsoffline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (networkAware.serverAvailable == false) {
      return AlertAnimated(
        child: GestureDetector(
          onTap: () => ref.read(networkAwareProvider.notifier).refresh(),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text(
                        Localize.of(context).serverNotReachable,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ],
          ),
        ),
      );
    } else {
      if (widget.height == 0.0) {
        return Container();
      }
      return SizedBox(
        height: widget.height,
      );
    }
  }
}
