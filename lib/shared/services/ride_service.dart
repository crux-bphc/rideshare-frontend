import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rideshare/models/ride.dart';

class RideService {
  final Dio _dio;

  RideService(this._dio) {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<void> createRide(DateTime departureStartTime, DateTime departureEndTime, String? comments, int seats, String rideStart, String rideEnd) async {
    try {;
      await _dio.post(
        '${dotenv.env['BACKEND_API_URL']}rides/create/',
        data: {
          "departureStartTime": departureStartTime.toUtc().toIso8601String(),
          "departureEndTime": departureEndTime.toUtc().toIso8601String(),
          "comments": comments ?? '',
          "maxMemberCount": seats,
          "rideStart": rideStart,
          "rideEnd": rideEnd,
        },
      );
    } catch (e) {
      throw Exception('Failed to create ride: $e');
    }
  }

  Future<List<Ride>> searchRides(String startLocation, String endLocation, DateTime? from, DateTime? to) async {
    try {
      if (from == null){
        final response = await _dio.get(
          '${dotenv.env['BACKEND_API_URL']}rides/search/',
          queryParameters: {
            "search_start_location": startLocation,
            "search_end_location": endLocation,
            "by": to?.toUtc().toIso8601String(),
          },
        );
        if (response.statusCode == 200) {
          return (response.data as List)
              .map((json) => Ride.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to search rides');
        }
      }
      else {
        final response = await _dio.get(
          '${dotenv.env['BACKEND_API_URL']}rides/search/',
          queryParameters: {
            "search_start_location": startLocation,
            "search_end_location": endLocation,
            "from": from.toUtc().toIso8601String(),
          },
        );
        if (response.statusCode == 200) {
          return (response.data as List)
              .map((json) => Ride.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to search rides');
        }
      }
    } catch (e) {
      throw Exception('Failed to search rides: $e');
    }
  }

  Future<void> sendRequest(int rideId) async{
    try{
       _dio.post(
        await '${dotenv.env['BACKEND_API_URL']}rides/request/$rideId',
      );
      print("Successfully sent request");
    }
    catch(e){
      throw Exception('Failed to send request: $e');
    }
  }
}