import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<bool> checkUserExists() async {
    try {
      // print
      final response = await _dio.get(
        '${dotenv.env['BACKEND_API_URL']}user/',
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
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
}
