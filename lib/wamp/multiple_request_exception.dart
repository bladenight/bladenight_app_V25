import 'dart:async';

class MultipleRequestException extends TimeoutException implements Exception {
  /// Description of the cause .
  @override
  final String? message;

  MultipleRequestException(this.message) : super('');

  @override
  String toString() {
    String result = '';
    if (duration != null) result = 'TimeoutException after $duration';
    if (message != null) result = message!;
    return result;
  }
}
