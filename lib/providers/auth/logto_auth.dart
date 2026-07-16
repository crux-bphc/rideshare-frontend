import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/auth_user.dart';

/// Logto auth: **access token** on all [dioClient] API calls; **ID token** only for [AuthUser] profile claims.
class LogtoAuthProvider extends AuthProvider {
  late final LogtoClient _logtoClient;

  @override
  late final Dio dioClient;

  static const redirectScheme = 'com.crux-bphc.rideshare';
  static const redirectUri = 'com.crux-bphc.rideshare://callback';
  static const postLogoutRedirectUri = 'com.crux-bphc.rideshare://callback';
  late final String _apiResource;

  /// Builds [AuthUser] from OIDC **ID token** claims (not used for API Authorization).
  AuthUser? _getAuthUserFromIdToken(String? idToken) {
    print('[Logto] _getAuthUserFromIdToken called with idToken: ${idToken != null ? "present" : "null"}');
    if (idToken == null) return null;

    try {
      final Map<String, dynamic> claims = JwtDecoder.decode(idToken);
      print('[Logto] ID token claims (profile): sub=${claims['sub']}, email=${claims['email']}');
      return AuthUser.fromJwtClaims(claims);
    } catch (e) {
      print('[Logto] ERROR: Failed to decode ID token - $e');
      return null;
    }
  }

  /// Restores profile from stored tokens; refreshes session when the ID token is expired.
  Future<AuthUser?> _resolveAuthUser() async {
    if (!await _logtoClient.isAuthenticated) return null;

    var idToken = await _logtoClient.idToken;
    if (idToken != null && JwtDecoder.isExpired(idToken)) {
      print('[Logto] ID token expired; refreshing via refresh token');
      try {
        await _logtoClient.getAccessToken(resource: _apiResource);
        idToken = await _logtoClient.idToken;
      } catch (e) {
        print('[Logto] Session refresh failed: $e');
        return null;
      }
    }

    return _getAuthUserFromIdToken(idToken);
  }

  /// Access token for [API_RESOURCE]; refreshed by Logto when expired.
  @override
  Future<String?> getAccessTokenForApi() async {
    final accessTokenObj =
        await _logtoClient.getAccessToken(resource: _apiResource);
    return accessTokenObj?.token;
  }

  Future<void> _attachApiAuthorization(RequestOptions options) async {
    try {
      final accessToken = await getAccessTokenForApi();
      if (accessToken == null || accessToken.isEmpty) {
        print('[Logto] ✗ access token is null/empty for ${options.path}');
        return;
      }

      options.headers['Authorization'] = 'Bearer $accessToken';
    } catch (e) {
      print('[Logto] ✗ ERROR retrieving access token in interceptor: $e');
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
          await _attachApiAuthorization(options);
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

    final user = await _resolveAuthUser();
    print('[Logto] Is authenticated on init: ${user != null}');
    return user;
  }

  @override
  Future<AuthUser?> login() async {
    print('[Logto] Login started with redirectUri: $redirectUri');
    await _logtoClient.signIn(redirectUri);
    print('[Logto] signIn completed');

    final user = await _resolveAuthUser();
    print('[Logto] User extracted from ID token: ${user?.name ?? "null"}');
    return user;
  }

  @override
  Future<void> logout() async {
    print('[Logto] Logout started');
    await _logtoClient.signOut(postLogoutRedirectUri);
    print('[Logto] Logout completed successfully');
  }

  /// OIDC ID token — profile/session only; do not send to the CabShare API.
  @override
  Future<String?> get idToken => _logtoClient.idToken;

  @override
  void dispose() {}
}

final logtoAuthProvider = Provider<LogtoAuthProvider>((ref) {
  final provider = LogtoAuthProvider();
  ref.onDispose(() => provider.dispose());
  return provider;
});
