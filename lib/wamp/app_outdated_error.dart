
class OutdatedAppError {
  final String message;

  OutdatedAppError(this.message);

  @override
  String toString() {
    return 'OutdatedAppError{message: $message}';
  }
}