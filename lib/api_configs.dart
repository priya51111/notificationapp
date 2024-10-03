// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';


/// for dio header

String baseUrl = 'https://app-project-7.onrender.com';

///for task
String createTaskUrl = baseUrl + '/api/task/createtask';
String getbyidTaskUrl = baseUrl + '/api/task/gettask/:userId/:date';
String updateTaskUrl = baseUrl + '/api/task/updatetask/:id';
String deleteTaskUrl = baseUrl + '/api/task/delete/:id';

/// for menu
String createMenuUrl = baseUrl + '/api/menu/menu';
String updateMenuUrl = baseUrl + '/api/menu/updatemenu/:id';
String deleteMenuUrl = baseUrl + '/api/menu/menu/:id';
String getbyidMenuUrl = baseUrl + '/api/menu/getbyid/:userId/:date';

///for user

String createUserUrl = baseUrl + '/api/user';
String deleteUserUrl = baseUrl + '/api/deleteUser/:id';
String updateUserUrl = baseUrl + '/api/user/:id';
String loginUrl = baseUrl + '/api/login';
