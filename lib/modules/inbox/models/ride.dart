class Ride {
  final String title;
  final String subtitle;
  final String timeAgo;
  final String date;
  final String startTime;
  final String endTime;
  final String stop;
  final String seats;
  final String status; // "pending", "accepted", "declined"

   const Ride({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.date,
    required this.endTime,
    required this.startTime,
    required this.stop,
    required this.seats,
    required this.status,
});
}