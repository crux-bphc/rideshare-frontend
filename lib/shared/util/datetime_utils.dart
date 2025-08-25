
import 'package:flutter/material.dart';

DateTime? combineDateAndTime(DateTime? date, TimeOfDay? time) {
  if (date != null && time != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
  else {
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