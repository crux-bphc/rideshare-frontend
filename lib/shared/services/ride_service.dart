import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rideshare/models/ride.dart';

class RideService {
  final Dio _dio;

  RideService(this._dio);

  Future<List<Ride>> searchRidesByLocation(String searchQuery) async {
    try {
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}/rides/search/location/',
        queryParameters: {'search_query': searchQuery},
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Ride.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search rides by location');
      }
    } catch (e) {
      throw Exception('Failed to search rides by location: $e');
    }
  }

  Future<List<Ride>> searchRidesByTime({
    DateTime? from,
    DateTime? by,
  }) async {
    if (from == null && by == null) {
      throw ArgumentError('Either from or by must be provided.');
    }
    if (from != null && by != null) {
      throw ArgumentError('Only one of from or by can be provided.');
    }

    try {
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}/rides/search/time/',
        queryParameters: {
          if (from != null) 'from': from.toIso8601String(),
          if (by != null) 'by': by.toIso8601String(),
        },
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Ride.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search rides by time');
      }
    } catch (e) {
      throw Exception('Failed to search rides by time: $e');
    }
  }
}
