
import 'email_validator.dart';

bool validateEmail(String? value) {
  if (value == null) return false;
  return EmailValidator.validate(value);
}
