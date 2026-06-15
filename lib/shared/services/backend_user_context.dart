import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Logs ID vs access token claim keys once per session (debug only).
void debugLogLogtoTokenClaims({
  required String? idToken,
  required String? accessToken,
}) {
  if (!kDebugMode) return;

  if (idToken != null) {
    try {
      final claims = JwtDecoder.decode(idToken);
      print(
        '[Logto][debug] ID token claims: ${claims.keys.toList()} '
        'email=${claims['email']} aud=${claims['aud']}',
      );
    } catch (e) {
      print('[Logto][debug] ID token decode failed: $e');
    }
  }

  if (accessToken != null) {
    try {
      final claims = JwtDecoder.decode(accessToken);
      print(
        '[Logto][debug] Access token claims: ${claims.keys.toList()} '
        'email=${claims['email']} aud=${claims['aud']} scope=${claims['scope']}',
      );
      if (claims['email'] == null) {
        print(
          '[Logto][debug] Access token has no email claim — backend '
          'res.locals.user.email will be undefined unless Logto adds custom JWT claims.',
        );
      }
    } catch (e) {
      print('[Logto][debug] Access token decode failed (opaque token?): $e');
    }
  }
}

/// Backend auth uses JWT payload email only ([res.locals.user.email]).
/// Query/header/body email on other routes is ignored — do not attach here.
void attachBackendUserEmail(RequestOptions options, String email) {
  // Intentionally empty: CabShare protected routes read email from the verified JWT only.
  // Profile lookup uses an explicit query param in [UserService.getUserDetails].
}
