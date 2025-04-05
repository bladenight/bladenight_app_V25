enum WampExceptionReason {
  unknown,
  timeout,
  timeout10sec,
  timeout60sec,
  outdated,
  wampStopped,
  connectionError,
  offline,
  wampMessageError
}

class WampException implements Exception {
  /// Description of the cause.

  final String message;
  final WampExceptionReason reason;

  WampException(this.reason, {this.message = ''});

  @override
  String toString() {
    return 'WampException Reason: ${reason.name} Message: $message';
  }
}
