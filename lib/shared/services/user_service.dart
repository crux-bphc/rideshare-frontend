import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/models/user.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<String?> getUserEmail() async {
    try {
      // print
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/',
      );
      return response.data['email'];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to check user existence: $e');
    }
  }

  Future<void> createUser(String phone, String name) async {
    try {
      await _dio.post(
        '${dotenv.env['BACKEND_API_URL']}user/',
        data: {
          "phoneNumber": phone,
          "name": name,
        },
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> getUserDetails(String email) async{
    try{
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/email/',
        queryParameters: {'email' : email},
      );
      if (response.statusCode == 200) {
          return User.fromJson(response.data);
        } else {
          throw Exception('Failed to search rides');
        }
    }
    catch(e){
      throw Exception("Failed to get user details");
    }
  }

  Future<List<RideRequest>> getRequestsReceived() async{
    try{
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/requests/received',
      );
      if (response.statusCode == 200){
        return (response.data as List).map((json) => RideRequest.fromJson(json)).toList();
      }
      else{
        throw Exception("Failed to get Received Requests");
      }
    }
    catch(e){
      throw Exception("Failed to get Received Requests $e");
    }
  }
}
