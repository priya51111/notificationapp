import 'dart:convert';
import 'package:notificationapp/login/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String apiUrl = 'https://app-project-7.onrender.com/api'; // Replace with actual API
  
  Future<void> createUser(String mailId, String password) async {
    if (mailId.isEmpty || password.isEmpty) {
      throw Exception("Mail and password are missing");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      body: jsonEncode({
        'mailId': mailId,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }

    final user = User(
      userId: generateUserId(),
      mailId: mailId,
      password: password,
    );

    final users = await getUsersFromLocal();
    users.add(user);
    await saveUsersToLocal(users);
  }

  Future<AuthResponse> signIn(String mailId, String password) async {
    if (mailId.isEmpty || password.isEmpty) {
      throw Exception("Mail and password are missing");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/login'),
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
    List<String> userList = users.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList('users', userList);
  }

  Future<List<User>> getUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      return userList.map((userStr) => User.fromJson(json.decode(userStr))).toList();
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
