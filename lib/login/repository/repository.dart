import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:notificationapp/login/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String apiUrl =
      'https://app-project-9.onrender.com'; 
 Future<User> createUser(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    throw Exception("Email and password must not be empty.");
  }

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/api/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    Logger().i("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      if (responseBody['data'] != null && responseBody['data']['user'] != null) {
        final userJson = responseBody['data']['user'];
        final user = User.fromJson(userJson);
        return user;
      } else {
        throw Exception("User data is null");
      }
    } else if (response.statusCode == 400) {
      throw Exception("Bad Request: ${response.body}");
    } else if (response.statusCode == 500) {
      throw Exception("Server Error: ${response.body}");
    } else {
      throw Exception("Unexpected error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    Logger().e("Error creating user: $e");
    throw Exception('Failed to create user');
  }
}



  Future<AuthResponse> signIn(String mailId, String password) async {
    if (mailId.isEmpty || password.isEmpty) {
      throw Exception("Mail and password are missing");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      body: jsonEncode({
        'mailId': mailId,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', authResponse.token);
      prefs.setString('tokenExpiry', authResponse.expiry.toIso8601String());

      return authResponse;
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('tokenExpiry');
  }

  Future<void> saveUsersToLocal(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userList =
        users.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList('users', userList);
  }

  Future<List<User>> getUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      return userList
          .map((userStr) => User.fromJson(json.decode(userStr)))
          .toList();
    }
    return [];
  }

  String generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenExpiry = prefs.getString('tokenExpiry');
    if (tokenExpiry == null) return true;

    final expiryDate = DateTime.parse(tokenExpiry);
    return DateTime.now().isAfter(expiryDate);
  }
}
