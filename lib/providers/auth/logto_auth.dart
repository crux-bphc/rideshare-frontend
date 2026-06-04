import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/auth_user.dart';

class LogtoAuthProvider extends AuthProvider {
  late final LogtoClient _logtoClient;

  @override
  late final Dio dioClient;

  static const redirectScheme = 'com.crux-bphc.rideshare';
  static const redirectUri = 'com.crux-bphc.rideshare://callback';
  static const postLogoutRedirectUri = 'com.crux-bphc.rideshare://callback';
  late final String _apiResource;

  AuthUser? _getAuthUserFromIdToken(String? idToken) {
    print('[Logto] _getAuthUserFromIdToken called with idToken: ${idToken != null ? "present" : "null"}');
    if (idToken == null) return null;

    final isExpired = JwtDecoder.isExpired(idToken);
    if (isExpired) {
      print('[Logto] ERROR: idToken is expired');
      return null;
    }

    try {
      final Map<String, dynamic> claims = JwtDecoder.decode(idToken);
      print('[Logto] JWT claims decoded successfully: sub=${claims['sub']}, email=${claims['email']}');
      return AuthUser.fromJwtClaims(claims);
    } catch (e) {
      print('[Logto] ERROR: Failed to decode JWT - $e');
      return null;
    }
  }

  @override
  Future<AuthUser?> initialise() async {
    print('[LogtoAuthProvider] ===== INITIALISE CALLED =====');

    final appId = dotenv.env['CLIENT_ID'];
    final endpoint = dotenv.env['AUTH_DISCOVERY_URL'];
    final apiResource = dotenv.env['API_RESOURCE'];

    if (appId == null || endpoint == null || apiResource == null) {
      throw Exception('Missing CLIENT_ID, AUTH_DISCOVERY_URL, or API_RESOURCE in .env');
    }

    _apiResource = apiResource;

    _logtoClient = LogtoClient(
      config: LogtoConfig(
        appId: appId,
        endpoint: endpoint,
        resources: [apiResource],
        scopes: [
          'openid',
          'profile',
          LogtoUserScope.email.value,
          LogtoUserScope.phone.value,
        ],
      ),
    );
    print('[Logto] LogtoClient created successfully');

    dioClient = Dio();
    print('[LogtoAuthProvider] Dio client created - Instance ID: ${dioClient.hashCode}');

    dioClient.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('[Logto] DIO Request START - Path: ${options.path}');
          try {
            final accessTokenObj = await _logtoClient.getAccessToken(resource: _apiResource);
            final accessToken = accessTokenObj?.token;
            print('[Logto] accessToken retrieved: ${accessToken != null ? "YES" : "NULL"}');
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('[Logto] ✓ Authorization header set with access token');
            } else {
              print('[Logto] ✗ accessToken is null/empty');
            }
          } catch (e) {
            print('[Logto] ✗ ERROR retrieving access token in interceptor: $e');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('[Logto] DIO Response - Status: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('[Logto] ✗ DIO Error - Status: ${error.response?.statusCode}, Message: ${error.message}');
          print('[Logto] Error response: ${error.response?.data}');
          if (error.response?.statusCode == 401) {
            print('[Logto] ✗ 401 UNAUTHORIZED');
          }
          return handler.next(error);
        },
      ),
    );

    final isAuthenticated = await _logtoClient.isAuthenticated;
    print('[Logto] Is authenticated on init: $isAuthenticated');

    if (isAuthenticated) {
      final idToken = await _logtoClient.idToken;
      return _getAuthUserFromIdToken(idToken);
    }

    return null;
  }

  @override
  Future<AuthUser?> login() async {
    print('[Logto] Login started with redirectUri: $redirectUri');
    await _logtoClient.signIn(redirectUri);
    print('[Logto] signIn completed');

    final isAuthenticated = await _logtoClient.isAuthenticated;
    print('[Logto] After signIn - isAuthenticated: $isAuthenticated');

    if (isAuthenticated) {
      final idToken = await _logtoClient.idToken;
      final user = _getAuthUserFromIdToken(idToken);
      print('[Logto] User extracted from token: ${user?.name ?? "null"}');
      return user;
    }

    return null;
  }

  @override
  Future<void> logout() async {
    print('[Logto] Logout started');
    await _logtoClient.signOut(postLogoutRedirectUri);
    print('[Logto] Logout completed successfully');
  }

  @override
  Future<String?> get idToken => _logtoClient.idToken;

  Future<String?> getAccessToken() async {
  final accessTokenObj = await _logtoClient.getAccessToken(resource: _apiResource);
  return accessTokenObj?.token;
}

  @override
  void dispose() {}
}

final logtoAuthProvider = Provider<LogtoAuthProvider>((ref) {
  final provider = LogtoAuthProvider();
  ref.onDispose(() => provider.dispose());
  return provider;
});