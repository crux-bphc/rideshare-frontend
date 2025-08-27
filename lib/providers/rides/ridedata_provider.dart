import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    return null;
  }

  void setDate(DateTime? date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime?>(
  () {
    return SelectedDateNotifier();
  },
);

class DepartureTimeNotifier extends Notifier<TimeOfDay?> {
  @override
  TimeOfDay? build() {
    return null;
  }

  void setTime(TimeOfDay? time) {
    state = time;
  }
}

final departureTimeProvider =
    NotifierProvider<DepartureTimeNotifier, TimeOfDay?>(() {
      return DepartureTimeNotifier();
    });

class ArrivalTimeNotifier extends Notifier<TimeOfDay?> {
  @override
  TimeOfDay? build() {
    return null;
  }

  void setTime(TimeOfDay? time) {
    state = time;
  }
}

final arrivalTimeProvider = NotifierProvider<ArrivalTimeNotifier, TimeOfDay?>(
  () {
    return ArrivalTimeNotifier();
  },
);

class SeatNotifier extends Notifier<int> {
  @override
  int build() {
    return 4;
  }

  void increaseSeats(int seats) {
    state++;
  }

  void decreaseSeats(int seats) {
    state--;
  }
}

final seatProvider = NotifierProvider<SeatNotifier, int>(() {
  return SeatNotifier();
});
