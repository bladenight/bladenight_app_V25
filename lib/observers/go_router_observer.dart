import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GoRouterNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('did push route from $previousRoute to $route');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('did pop route from $previousRoute to $route');
    }
  }
}
