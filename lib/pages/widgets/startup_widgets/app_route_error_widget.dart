import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouteErrorWidget extends StatelessWidget {
  const AppRouteErrorWidget(
      {super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                  'Sorry, da ist was schief gelaufen - Startseite öffnen'),
            ),
            Image(
              image: AssetImage('assets/images/skatemunich_child_stop.png'),
            ),
          ],
        ),
      ),
    );
  }
}
