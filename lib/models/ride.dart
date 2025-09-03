class Ride {
  final int id;
  final String createdBy;
  final String? comments;
  final DateTime? departureStartTime;
  final DateTime? departureEndTime;
  final int? maxMemberCount;
  final String? rideStartLocation;
  final String? rideEndLocation;
  bool isBookmarked;

  Ride({
    required this.id,
    required this.createdBy,
    this.comments,
    this.departureStartTime,
    this.departureEndTime,
    this.maxMemberCount,
    this.isBookmarked = false,
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
      rideStartLocation: json['rideStartLocation'],
      rideEndLocation: json['rideEndLocation'],
      isBookmarked: json['isBookmarked'] ?? false,
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
      'rideStartLocation': rideStartLocation,
      'rideEndLocation': rideEndLocation,
      'isBookmarked': isBookmarked,
    };
  }
}
