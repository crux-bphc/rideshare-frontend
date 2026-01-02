import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime? combineDateAndTime(DateTime? date, TimeOfDay? time) {
  if (date != null && time != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  } else {
    return null;
  }
}

String formatDate(DateTime? date) {
  if (date == null) return "";
  return "${date.day}/${date.month}/${date.year}";
}

String formatTime(TimeOfDay? time) {
  if (time == null) return "";
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String formatTimeRange(DateTime? start, DateTime? end) {
  if (start == null) return '';
  final startStr = DateFormat('hh:mm a').format(start);
  if (end != null) {
    final endStr = DateFormat('hh:mm a').format(end);
    return '$startStr - $endStr';
  }
  return startStr;
}
