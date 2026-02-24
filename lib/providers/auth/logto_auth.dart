import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/auth_user.dart';

class LogtoAuthProvider extends AuthProvider {
  late final LogtoClient _logtoClient;
  late final String _apiResource;

  @override
  late final Dio dioClient;
  static const redirectScheme = 'com.crux-bphc.rideshare';
  static const redirectUri = 'com.crux-bphc.rideshare://callback';
  static const postLogoutRedirectUri = 'com.crux-bphc.rideshare://callback';

  AuthUser? _getAuthUserFromIdToken(String? idToken) {
    if (idToken == null || JwtDecoder.isExpired(idToken)) {
      return null;
    }
    final Map<String, dynamic> claims = JwtDecoder.decode(idToken);
    return AuthUser.fromJwtClaims(claims);
  }

  @override
  Future<AuthUser?> initialise() async {
    final appId = dotenv.env['CLIENT_ID'];
    final endpoint = dotenv.env['AUTH_DISCOVERY_URL'];
    final apiResource = dotenv.env['BACKEND_API_URL'];

    if (appId == null || endpoint == null) {
      throw Exception('Missing CLIENT_ID or AUTH_DISCOVERY_URL in .env');
    }
    if (apiResource == null || apiResource.isEmpty) {
      throw Exception('Missing BACKEND_API_URL in .env');
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

    dioClient = Dio();

    dioClient.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //getaccesstoken should ideally return the cached token or issue a new refresh token for this to work, leseee
          final accessToken = await _logtoClient.getAccessToken(
            resource: _apiResource,
          );
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${accessToken.token}';
          }
          return handler.next(options);
        },
      ),
    );

    if (await _logtoClient.isAuthenticated) {
      return _getAuthUserFromIdToken(await _logtoClient.idToken);
    }
    return null;
  }

  @override
  Future<AuthUser?> login() async {
    await _logtoClient.signIn(redirectUri);
    if (await _logtoClient.isAuthenticated) {
      return _getAuthUserFromIdToken(await _logtoClient.idToken);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _logtoClient.signOut(postLogoutRedirectUri);
  }

  @override
  Future<String?> get idToken => _logtoClient.idToken;

  @override
  Future<String?> getAccessToken(String resource) async {
    final token = await _logtoClient.getAccessToken(resource: resource);
    return token?.token;
  }

  @override
  void dispose() {}
}

final logtoAuthProvider = Provider<LogtoAuthProvider>((ref) {
  final authProvider = LogtoAuthProvider();
  ref.onDispose(() {
    authProvider.dispose();
  });
  return authProvider;
});
