import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';  // Import GetStorage
import '../model.dart';

class MenuRepository {
  final String createMenuUrl =
      'https://app-project-9.onrender.com/api/menu/menu';
  
  final GetStorage box = GetStorage();  // Initialize GetStorage instance

  Future<List<Menus>> getMenuList(String userId, String date) async {
    final String getByIdMenuUrl =
        'https://app-project-9.onrender.com/api/menu/getbyid/$userId/$date';

    final response = await http.get(Uri.parse(getByIdMenuUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Menus> menuList = data.map((menu) => Menus.fromJson(menu)).toList();
      return menuList;
    } else {
      throw Exception('Failed to load menu list: ${response.body}');
    }
  }

  Future<String> createMenu(String menuName, String date) async {
    final userId = box.read('userId');
    if (userId == null) {
      throw Exception('User ID is missing');
    }

    final token = await _getToken();  // Retrieve token from local storage
    if (token == null) {
      throw Exception('Token is missing');
    }

    try {
      final response = await http.post(
        Uri.parse(createMenuUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add token in headers
        },
        body: jsonEncode({
          'menuName': menuName,
          'date': date,
          'userId': userId,  // Send userId in the body
        }),
      );

      // Log the response for debugging
      Logger().i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final menuId = data['menuId'];  // Assuming backend sends 'menuId'

        // Store the menuId in local storage for later use
        box.write('menuId', menuId);
        return menuId;  // Return the menuId
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      Logger().e("Error creating menu: $e");
      throw Exception('Failed to create menu');
    }
  }

  // Helper method to retrieve token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to retrieve the saved menuId
  String? getSavedMenuId() {
    return box.read('menuId');
  }
}
