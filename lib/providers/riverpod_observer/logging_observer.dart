import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network_connection_provider.dart';

class LoggingObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    //var stack = StackTrace.current;
    print(
        '${DateTime.now().toIso8601String()} Provider $provider was initialized with $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    print(
        '${DateTime.now().toIso8601String()} Provider $provider was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (previousValue is NetworkStateModel) {
      var previous = previousValue;
      var newVal = newValue as NetworkStateModel;
      print(
          '${DateTime.now().toIso8601String()} Provider NetworkStateModel updated from ${previous.connectivityStatus} to ${newValue.connectivityStatus}');
    } else {
      print(
          '${DateTime.now().toIso8601String()} Provider $provider updated from ${previousValue.toString()} to $newValue');
    }
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print(
        '${DateTime.now().toIso8601String()} Provider $provider threw $error at $stackTrace');
  }
}
