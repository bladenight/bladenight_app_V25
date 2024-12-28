import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/network_connection_provider.dart';
import '../../wamp/wamp_v2.dart';
import 'alert_animated_widget.dart';
import 'no_alert_animated_widget.dart';

class ConnectionWarning extends ConsumerStatefulWidget {
  const ConnectionWarning(
      {super.key,
      this.reason,
      this.height = 40,
      this.shimmerAnimationController});

  final Exception? reason;
  final double height;
  final AnimationController? shimmerAnimationController;

  @override
  ConsumerState<ConnectionWarning> createState() => _ConnectionWarning();
}

class _ConnectionWarning extends ConsumerState<ConnectionWarning>
    with SingleTickerProviderStateMixin {
  late Animation _fadeInAnimation;
  late AnimationController _fadeAnimationController;
  bool wampConnected = false;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeInAnimation =
        Tween<double>(begin: 1.0, end: widget.height).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.linear,
    ));
    _fadeAnimationController.addListener(() {
      if (_fadeAnimationController.status.isCompleted &&
          WampV2().webSocketIsConnected) {
        //remove item if connected and faded out
        setState(() {
          wampConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  String getAlertText(ConnectivityStatus status) {
    switch (status) {
      case ConnectivityStatus.unknown:
        return Localize.of(context).connecting;
      case ConnectivityStatus.internetOffline:
        return Localize.of(context).seemsoffline;
      case ConnectivityStatus.wampConnected:
        return Localize.of(context).serverConnected;
      case ConnectivityStatus.wampNotConnected:
        return Localize.of(context).serverNotReachable;
    }
  }

  @override
  Widget build(BuildContext context) {
    var networkAware = ref.watch(networkAwareProvider);
    if (networkAware.connectivityStatus != ConnectivityStatus.wampConnected) {
      wampConnected = false;
      _fadeAnimationController.forward();
    } else if (networkAware.connectivityStatus ==
        ConnectivityStatus.wampConnected) {
      if (_fadeAnimationController.value == 0) {
        //avoid placeholder size if wamp is connected on first load
        wampConnected = true;
      } else {
        _fadeAnimationController.reverse();
      }
    }
    return wampConnected
        ? Container()
        : SafeArea(
            child: AnimatedBuilder(
                animation: _fadeInAnimation,
                builder: (BuildContext context, _) {
                  if (networkAware.connectivityStatus !=
                      ConnectivityStatus.wampConnected) {
                    return SizedBox(
                        height: _fadeInAnimation.value ?? 20,
                        child: AlertAnimated(
                          animationController:
                              widget.shimmerAnimationController,
                          child: GestureDetector(
                            onTap: () => ref
                                .read(networkAwareProvider.notifier)
                                .refresh(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        getAlertText(
                                            networkAware.connectivityStatus),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  } else {
                    return SizedBox(
                      height: _fadeInAnimation.value ?? 0,
                      child: NoAlertAnimated(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Localize.of(context).serverConnected,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }));
  }
}
