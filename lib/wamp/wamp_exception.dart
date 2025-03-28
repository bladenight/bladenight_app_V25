// ignore_for_file: overridden_fields

import 'dart:async';

class WampException extends TimeoutException implements Exception {
  /// Description of the cause .
  @override
  final String? message;

  WampException(this.message) : super('');

  @override
  String toString() {
    String result = '';
    if (duration != null) result = 'TimeoutException after $duration';
    if (message != null) result = message!;
    return result;
  }
}

enum WampExceptionMessageType { wampStopped, timeout10sec, connectionError }
