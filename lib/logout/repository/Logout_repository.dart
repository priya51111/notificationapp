import 'dart:convert';
import 'package:http/http.dart' as http;

class LogoutRepository {
  final String apiUrl = 'https://app-project-9.onrender.com';

  Future<void> deleteUser({required String userId, required String token}) async {
    final url = Uri.parse('$apiUrl/api/deleteUser/:id'); 

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
