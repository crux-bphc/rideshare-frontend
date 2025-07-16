import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

final String _appId = const String.fromEnvironment("CLIENT_ID");
final String _endpoint = const String.fromEnvironment("AUTH_DISCOVERY_URL");

class LogtoAuthProvider extends AuthProvider {
  final _currentUser = signal<AuthUser?>(null);
  late final LogtoClient _logtoClient;

  @override
  late final Dio dioClient;

  static const redirectScheme = 'com.crux-bphc.rideshare';
  static const redirectUri = 'com.crux-bphc.rideshare://callback';
  static const postLogoutRedirectUri = 'com.crux-bphc.rideshare://callback';

  @override
  late final currentUser = _currentUser.readonly();

  Future<void> _updateUserFromToken() async {
    final idToken = await _logtoClient.idToken;
    if (idToken == null || JwtDecoder.isExpired(idToken)) {
      _currentUser.value = null;
      return;
    }
    final Map<String, dynamic> claims = JwtDecoder.decode(idToken);
    _currentUser.value = AuthUser.fromJwtClaims(claims);
  }

  @override
  Future<void> initialise() async {
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
      await _updateUserFromToken();
    }
  }

  @override
  Future<void> login() async {
    await _logtoClient.signIn(redirectUri);
    if (await _logtoClient.isAuthenticated) {
      await _updateUserFromToken();
    }
  }

  @override
  Future<void> logout() async {
    await _logtoClient.signOut(postLogoutRedirectUri);
    _currentUser.value = null;
  }

  @override
  void dispose() {}
}