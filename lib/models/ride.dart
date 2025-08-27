class Ride {
  final int id;
  final String createdBy;
  final String? comments;
  final DateTime? departureStartTime;
  final DateTime? departureEndTime;
  final int? maxMemberCount;
  final String? rideStartLocation;
  final String? rideEndLocation;

  Ride({
    required this.id,
    required this.createdBy,
    this.comments,
    this.departureStartTime,
    this.departureEndTime,
    this.maxMemberCount,
    this.rideStartLocation,
    this.rideEndLocation,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      createdBy: json['createdBy'],
      comments: json['comments'],
      departureStartTime: json['departureStartTime'] != null
          ? DateTime.parse(json['departureStartTime'])
          : null,
      departureEndTime: json['departureEndTime'] != null
          ? DateTime.parse(json['departureEndTime'])
          : null,
      maxMemberCount: json['maxMemberCount'],
      rideStartLocation: json['ride_start_location'],
      rideEndLocation: json['ride_end_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'comments': comments,
      'departureStartTime': departureStartTime?.toIso8601String(),
      'departureEndTime': departureEndTime?.toIso8601String(),
      'maxMemberCount': maxMemberCount,
      'ride_start_location': rideStartLocation,
      'ride_end_location': rideEndLocation,
    };
  }
}
