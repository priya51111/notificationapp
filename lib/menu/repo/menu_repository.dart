import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model.dart';


class MenuRepository {
     final String createMenuUrl =
        'https://app-project-9.onrender.com/api/menu/menu';
        

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

  Future<Menus> addMenu(Menus menus) async {
   
    final response = await http.post(
      Uri.parse(createMenuUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "menuName": menus.menuName,
        "userId":menus. userId,
        "date": menus.date,
      }),
    );

    if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final menuId = responseData['menuId'];
          return Menus(
      menuId: menuId,
      menuName: menus.menuName,
      userId: menus.userId,
      date: menus.date,
    );
      } else {
        
        throw Exception('Failed to create task');
      }
  }
}
