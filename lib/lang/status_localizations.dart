import 'package:intl/intl.dart';

//flutter pub run intl_generator:generate_from_arb :extract_to_arb --output-dir=lib/l10n lib/src/lang/status_localizations.dart
class StatusLocalizations {
  //TODO Map to translations
  String statusTranslation(String status) => Intl.select(status, {
    'status_pending': 'pending',
    'status_confirmed': 'confirmed',
    'status_canceled': 'canceled',
  });
}
