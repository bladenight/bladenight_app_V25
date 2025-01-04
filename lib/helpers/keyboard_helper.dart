import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void dismissKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
