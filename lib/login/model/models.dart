class User {
  final String email;
  final String password; // Consider storing hashed password securely
  final String id;

  User({required this.email, required this.password, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '', // Provide default value if null
      password: json['password'] ?? '', // Provide default value if null
      id: json['_id'] ?? '', // Provide default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      '_id': id,
    };
  }
}



class AuthResponse {
  final String token;
  final DateTime expiry;

  AuthResponse({required this.token, required this.expiry});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      expiry: DateTime.parse(json['expiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiry': expiry.toIso8601String(),
    };
  }
}
