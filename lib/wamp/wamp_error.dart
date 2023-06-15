class WampError implements Exception {
  final String message;

  WampError(this.message);

  @override
  String toString() {
    return 'WampError{message: $message}';
  }
}