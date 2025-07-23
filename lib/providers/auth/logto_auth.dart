import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

final String _appId = const String.fromEnvironment("CLIENT_ID");
final String _endpoint = const String.fromEnvironment("AUTH_DISCOVERY_URL");

class LogtoAuthProvider extends AuthProvider {
  late final LogtoClient _logtoClient;

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
    _logtoClient = LogtoClient(
      config: LogtoConfig(
        appId: _appId,
        endpoint: _endpoint,
      ),
    );

    dioClient = Dio();
    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _logtoClient.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
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
  void dispose() {}
}

final logtoAuthProvider = Provider<LogtoAuthProvider>((ref) {
  final authProvider = LogtoAuthProvider();
  ref.onDispose(() {
    authProvider.dispose();
  });
  return authProvider;
});

