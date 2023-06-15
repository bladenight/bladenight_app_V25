import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';

///Helperclass to convert times from server
class TimeConverter {
  ///Format minutes like 30 to time 00:30:00
  ///if [maxvalue] greater [value] '-' will returned
  static String minutesToDateTimeString({required int value, int? maxvalue}) {
    if (maxvalue != null && value > maxvalue) return '-';
    return formatDuration(Duration(minutes: value));
  }

  ///Format millisecond  to time 00:30:00
  ///if [maxvalue] greater [value] '-' will returned
  static millisecondsToDateTimeString({required int value, int? maxvalue}) {
    // if (maxvalue != null && value > maxvalue) return '-';
    return formatDuration(Duration(milliseconds: value));
  }

  ///Format DateTime to time in format dd. MMM yy, HH:mm
  static String getDateTimeString(DateTime dateTime) {
    return DateFormat('dd. MMM yy, HH:mm').format(dateTime);
  }

  /// Returns a formatted string for the given Duration [d] to be DD:HH:mm:ss
  /// and ignore if 0.
  static String formatDuration(Duration d) {
    //d = const Duration(milliseconds: 18451550); //5h:07m:31:55
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
      if (days >9){
          return tokens.join(':').trim();
      }
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    if (hours != 0 || days != 0) {
      return tokens.join(':').trim();
    }
    tokens.add('${seconds}s');
    return tokens.join(':').trim();
  }
}

class DateFormatter {
  DateFormatter(this.localizations);

  final DateTime _startTime2100 = DateTime(
    1,
    1,
    1,
    21,
    00,
  );

  Localize localizations = Localize.current;

  ///Convert [dateTime] to [DateTime] tomorrow, today else date and time
  String getLocalDayDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now().toUtc();
    DateTime utcDateTime = dateTime.toUtc();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    //today
    if (dateTime.year < now.year) return '-';
    if ((now.difference(utcDateTime)).inSeconds > 0) {
      return '${localizations.now} ${localizations.since} ${localizations.timeIntl(dateTime.toLocal())}';
    }

    if (utcDateTime.day == now.day &&
        utcDateTime.month == now.month &&
        utcDateTime.year == now.year) {
      return '${localizations.today} ${localizations.timeIntl(dateTime.toLocal())}';
    }
    //tomorrow
    if (utcDateTime.day == tomorrow.day &&
        utcDateTime.month == tomorrow.month &&
        utcDateTime.year == tomorrow.year) {
      return '${localizations.tomorrow} ${Localize.current.timeIntl(dateTime.toLocal())}';
    }
    //yesterday
    if (utcDateTime.day == yesterday.day &&
        utcDateTime.month == yesterday.month &&
        utcDateTime.year == yesterday.year) {
      return '${localizations.yesterday} ${localizations.timeIntl(dateTime.toLocal())}';
    }

    ///TODO sometime 19:00 shown - why??
    var res = Localize.current
        .dateTimeDayIntl(dateTime.toLocal(), dateTime.toLocal());
    if (res.contains('19:00')) {
      print('current locale ${Intl.getCurrentLocale()}');
      if (!kIsWeb) FLog.warning(text: 'wrong date');
      return Localize.current.dateTimeIntl(dateTime.toLocal(), _startTime2100);
    }
    return res;
  }

  ///Format DateTime to time in format dd. MMM yy, HH:mm:ss
  String getFullDateTimeString(DateTime dateTime) {
    return DateFormat('dd. MMM yy, HH:mm:ss').format(dateTime);
  }
}
