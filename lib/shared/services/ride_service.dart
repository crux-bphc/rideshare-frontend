import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rideshare/models/ride.dart';

class RideService {
  final Dio _dio;

  RideService(this._dio);

  Future<void> createRide(DateTime departureStartTime, DateTime departureEndTime, String? comments, int seats, String rideStart, String rideEnd) async {
    try {
      final response = await _dio.post(
        '${dotenv.env['BACKEND_API_URL']}rides/',
        data: {
          "departureStartTime": departureStartTime.toIso8601String(),
          "departureEndTime": departureEndTime.toIso8601String(),
          "comments": comments ?? '',
          "maxMemberCount": seats,
          "rideStart": rideStart,
          "rideEnd": rideEnd,
        },
      );
      print('Ride created successfully: ${response.data}');
    } catch (e) {
      throw Exception('Failed to create ride: $e');
    }
  }

  Future<List<Ride>> searchRides(String startLocation, String endLocation, DateTime? from, DateTime? to) async {
    try {
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}rides/search/',
        queryParameters: {
          "search_start_location": startLocation,
          "search_end_location": endLocation,
          "from": from?.toIso8601String(),
          "by": to?.toIso8601String(),
        },
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Ride.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search rides');
      }
    } catch (e) {
      throw Exception('Failed to search rides: $e');
    }
  }
}