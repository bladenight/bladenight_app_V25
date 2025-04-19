enum LocationExceptionReason { unknown, timeout, invalidPosition }

class LocationException implements Exception {
  /// Description of the cause.

  final String message;
  final LocationExceptionReason reason;

  LocationException(this.reason, {this.message = ''});

  @override
  String toString() {
    return 'LocationException Reason: ${reason.name} Message: $message';
  }
}
