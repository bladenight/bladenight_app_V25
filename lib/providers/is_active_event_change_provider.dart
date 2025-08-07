import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'active_event_provider.dart';

class IsActiveEventChangeNotifier extends ChangeNotifier {
  bool eventIsActive = false;

  void setActive() {
    eventIsActive = true;
    notifyListeners();
  }

  void setInactive() {
    eventIsActive = false;
    notifyListeners();
  }
}

final isActiveEventChangeNotifierProvider = ChangeNotifierProvider((ref) {
  var res = ref.watch(activeEventProvider);
  var prov = IsActiveEventChangeNotifier();
  if (res.isActive) {
    prov.setActive();
  }

  return prov;
}); //IsActiveEventChangeNotifier());
