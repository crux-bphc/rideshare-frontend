
class AuthUser {
  final String? uid;
  final String? name;
  final String? email;
  final String? picture;

  AuthUser.fromJwtClaims(Map<String, dynamic>? claims)
      : uid = claims?['sub'] as String?,
        name = claims?['name'] as String?,
        email = claims?['email'] as String?,
        picture = claims?['picture'] as String?;
}