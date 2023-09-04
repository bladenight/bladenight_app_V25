import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class BnLogOutput extends LogOutput {
  final  Box _logBox;

  BnLogOutput(this._logBox);

  @override
  void output(OutputEvent event) {
      print(event.lines);
  }

  @override
  Future<void> destroy() async {
    _logBox.flush();
    _logBox.close();
  }
}
