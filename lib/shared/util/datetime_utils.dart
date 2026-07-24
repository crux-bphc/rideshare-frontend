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

int getDurationMinutes(TimeOfDay start, TimeOfDay end) {
  int startMinutes = start.hour * 60 + start.minute;
  int endMinutes = end.hour * 60 + end.minute;
  if (endMinutes < startMinutes) {
    endMinutes += 24 * 60;
  }
  return endMinutes - startMinutes;
}

DateTime? combineArrivalDateAndTime(DateTime? date, TimeOfDay? departure, TimeOfDay? arrival) {
  if (date == null || departure == null || arrival == null) return null;
  DateTime arrivalDateTime = combineDateAndTime(date, arrival)!;
  int startMinutes = departure.hour * 60 + departure.minute;
  int endMinutes = arrival.hour * 60 + arrival.minute;
  if (endMinutes < startMinutes) {
    arrivalDateTime = arrivalDateTime.add(const Duration(days: 1));
  }
  return arrivalDateTime;
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
