import 'dart:core';

import 'package:intl/intl.dart';

import '../generated/l10n.dart';
import 'logger.dart';

///Helper class to convert times from server
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
    if (maxvalue != null && value > maxvalue) {
      return '~${formatDuration(Duration(milliseconds: maxvalue))}';
    }
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
      if (days > 9) {
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
    DateTime now = DateTime.now().toLocal();
    DateTime localDateTime = dateTime.toLocal();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    //today
    if (dateTime.year < now.year) return '-';
    if ((now.difference(localDateTime)).inSeconds > 0) {
      return '${localizations.now} ${localizations.since} ${localizations.timeIntl(localDateTime)}';
    }

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return '${localizations.today} ${localizations.timeIntl(localDateTime)}';
    }
    //tomorrow
    if (localDateTime.day == tomorrow.day &&
        localDateTime.month == tomorrow.month &&
        localDateTime.year == tomorrow.year) {
      return '${localizations.tomorrow} ${Localize.current.timeIntl(localDateTime)}';
    }
    //yesterday
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return '${localizations.yesterday} ${localizations.timeIntl(localDateTime)}';
    }

    ///TODO sometime 19:00 shown - why??
    var res = Localize.current
        .dateTimeDayIntl(dateTime.toLocal(), dateTime.toLocal());
    if (res.contains('19:00')) {
      print('current locale ${Intl.getCurrentLocale()}');
      BnLog.warning(text: 'wrong date');
      return Localize.current.dateTimeIntl(localDateTime, _startTime2100);
    }
    return res;
  }

  ///Format DateTime to time in format dd. MMM yy, HH:mm:ss
  String getFullDateTimeString(DateTime dateTime) {
    return DateFormat('dd. MMM yy, HH:mm:ss').format(dateTime);
  }

  /// Create Date from Timestamp (time is set to 0:0:0)
  static DateTime toDateOnly(DateTime dateTime) {
    var date = toDateOnly(
        dateTime); //  DateTime(dateTime.year, dateTime.month, dateTime.day);
    return date;
  }

  static DateTime fromString(String inputDate) {
    try {
      DateFormat format = DateFormat('yyyy-MM-dd');
      DateTime dateTime = format.parse(inputDate);
      return dateTime;
    } catch (e) {
      var today = DateTime.now();
      return DateTime(today.year, today.month, today.day);
    }
  }
}

/// Create Date from Timestamp (time is set to 0:0:0)
extension DateExtension on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  String toDateOnlyString() {
    var date = DateTime(year, month, day);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String toDeDateOnlyString() {
    var date = DateTime(year, month, day);
    return DateFormat('EE dd.MM.yyyy').format(date);
  }

  DateTime toTimeOnly() {
    return DateTime(year, month, day, hour, minute, second);
  }

  String toTimeOnlyString() {
    var date = DateTime(year, month, day, hour, minute, second);
    return DateFormat('HH:mm').format(date);
  }

  String toIso8601StringWithTimezone() {
    final timeZoneOffset = this.timeZoneOffset;
    final sign = timeZoneOffset.isNegative ? '-' : '+';
    final hours = timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes =
        timeZoneOffset.inMinutes.abs().remainder(60).toString().padLeft(2, '0');
    final offsetString = '$sign$hours:$minutes';
    final formattedDate = toIso8601String().split('.').first;

    return '$formattedDate$offsetString';
  }

  String toEventMessageDateTime() {
    return DateFormat('yyyy-MM-ddTHH:mm').format(this);
  }
}
