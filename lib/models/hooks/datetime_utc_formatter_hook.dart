import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';

import '../../helpers/logger/logger.dart' show BnLog;

class EventDateTimeHook extends MappingHook {
  const EventDateTimeHook();

  @override
  Object? beforeEncode(Object? value) {
    // can't implement two datetime SimpleMapper
    // after encode the [SimmpleMapper] dt is to short without seconds
    return super.beforeEncode(value);
  }

  @override
  Object? afterEncode(Object? value) {
    //server don't understand zulu time till V 1.0.12
    //from V1.0.13 implemented
    // on server dateFormatter = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm");
    if (value is String && value.toString().endsWith(':00.000Z')) {
      try {
        var df = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .tryParse(value.toString(), true);
        if (df != null) {
          var newDf = DateFormat("yyyy-MM-dd'T'HH:mm");
          var val = newDf.format(df);
          return val;
        }
      } catch (e) {
        BnLog.error(text: 'Could not parse $value');
      }
      var newStr = value.toString().replaceFirst(':00.000Z', '');
      return newStr;
    }
    return value;
  }

  @override
  Object? beforeDecode(Object? value) {
    // TODO: implement beforeDecode
    //stringValue
    return super.beforeDecode(value);
  }

  @override
  Object? afterDecode(Object? value) {
    // TODO: implement afterDecode
    /*try {
      var df = DateFormat('yyyy-MM-dd HH:mm:ss.fff')
          .tryParse(value.toString(), true);
      if (df != null) {
        return df;
      }
      var val = (value.toString());
      return DateTime.parse(val);
    } catch (e) {
      BnLog.error(text: 'Could not parse $value');
      rethrow;
    }*/
    return super.afterDecode(value);
  }
}
