import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rideshare/models/ride.dart';

class RideService {
  final Dio _dio;

  RideService(this._dio) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<void> createRide(
    DateTime departureStartTime,
    DateTime departureEndTime,
    String? comments,
    int seats,
    String rideStart,
    String rideEnd,
  ) async {
    try {
      print("params");
      print(departureStartTime.toIso8601String());
      print(departureEndTime.toIso8601String());
      print(comments);
      print(seats);
      print(rideStart);
      print(rideEnd);
      print("params");
      final response = await _dio.post(
        '${dotenv.env['BACKEND_API_URL']}rides/create/',
        data: {
          "departureStartTime": departureStartTime.toIso8601String(),
          "departureEndTime": departureEndTime.toIso8601String(),
          "comments": comments ?? '',
          "maxMemberCount": seats,
          "rideStartLocation": rideStart,
          "rideEndLocation": rideEnd,
        },
      );
      print("response");
      print(response);
      print("response");
      print('Ride created successfully: ${response.data}');
    } catch (e) {
      throw Exception('Failed to create ride: $e');
    }
  }

  Future<List<Ride>> searchRides(
    String startLocation,
    String endLocation,
    DateTime? from,
    DateTime? to,
  ) async {
    try {
      print("params");
      print(startLocation);
      print(endLocation);
      print(from?.toIso8601String());
      print(to?.toIso8601String());
      print("params");
      if (from == null) {
        final response = await _dio.get(
          '${dotenv.env['BACKEND_API_URL']}rides/search/',
          queryParameters: {
            "searchStartLocation": startLocation,
            "searchEndLocation": endLocation,
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
      } else {
        final response = await _dio.get(
          '${dotenv.env['BACKEND_API_URL']}rides/search/',
          queryParameters: {
            "searchStartLocation": startLocation,
            "searchEndLocation": endLocation,
            "from": from.toIso8601String(),
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

  Future<List<Ride>> getUpcomingRides() async {
    try {
      final joinedRidesResponse = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/rides/joined',
      );
      final createdRidesResponse = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/rides/created',
      );

      final List<Ride> joinedRides = (joinedRidesResponse.data as List)
          .map((json) => Ride.fromJson(json))
          .toList();
      final List<Ride> createdRides = (createdRidesResponse.data as List)
          .map((json) => Ride.fromJson(json))
          .toList();

      final allRides = [...joinedRides, ...createdRides];

      final uniqueUpcomingRides = <String, Ride>{};
      for (var ride in allRides) {
        if (ride.departureEndTime?.isAfter(DateTime.now()) ?? false) {
          uniqueUpcomingRides[ride.id.toString()] = ride;
        }
      }

      return uniqueUpcomingRides.values.toList();
    } catch (e) {
      throw Exception('Failed to get upcoming rides: $e');
    }
  }

  Future<List<Ride>> getBookmarkedRides() async {
    try {
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/bookmarks/get',
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Ride.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get bookmarked rides');
      }
    } catch (e) {
      throw Exception('Failed to get bookmarked rides: $e');
    }
  }

  Future<void> toggleBookmark(String rideId, bool isBookmarked) async {
    try {
      if (isBookmarked) {
        // await _dio.delete(
        //   '${dotenv.env['BACKEND_API_API_URL']}user/bookmarks/delete/$rideId',
        // );
      } else {
        await _dio.post(
          '${dotenv.env['BACKEND_API_URL']}user/bookmarks/create/$rideId',
        );
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }
}
