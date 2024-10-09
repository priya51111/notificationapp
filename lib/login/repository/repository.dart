import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:notificationapp/login/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String apiUrl = 'https://app-project-9.onrender.com';
  final box = GetStorage();
  final Logger logger = Logger(); // Initialize GetStorage

  Future<User> createUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Mail and password are missing");
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

      // Log the full response for debugging
      Logger().i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = User.fromJson(json.decode(response.body));

        // Store user ID in local storage
        box.write('userId', user.id); // Save the user ID
        return user;
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      Logger().e("Error creating user: $e");
      throw Exception('Failed to create user');
    }
  }

  // Method to retrieve user ID
  String? getUserId() {
    return box.read('userId');
  }

  Future<AuthResponse> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password cannot be empty");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // Log the response for debugging
    logger.i("Response Status Code: ${response.statusCode}");
    logger.i("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      if (token.isEmpty) {
        throw Exception('Invalid credentials: token or userId is missing');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return AuthResponse(token: token);
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
