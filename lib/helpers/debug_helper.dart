import 'package:flutter/foundation.dart';

debugPrintTime(String message) {
  debugPrint('${DateTime.now().toIso8601String()} $message');
}
