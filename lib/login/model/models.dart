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


  AuthResponse(
      {required this.token,});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],

     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      
    };
  }
}
