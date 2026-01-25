class User {
  final String email;
  final String phoneNumber;
  final String name;

  User({
    required this.email,
    required this.phoneNumber,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
    );
  }
}
