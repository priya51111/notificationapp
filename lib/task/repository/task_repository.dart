import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../model.dart';

class TaskRepository {  final String deleteUrl =
      'https://app-project-9.onrender.com/api/task/delete/:id';
  final String apiUrl =
      'https://app-project-9.onrender.com/api/task/createtask';
  final String updateUrl =
      'https://app-project-9.onrender.com/api/task/updatetask/:id';
  final Logger log = Logger();
  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task': task.task,
          'date': task.date,
          'time': task.time,
          'userId': task.userId,
          'menuId': task.menuId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final taskId = responseData['taskId'];
        return task.copyWith(taskId: taskId);
      } else {
        log.e('Failed to create task: ${response.statusCode}');
        throw Exception('Failed to create task');
      }
    } catch (error) {
      log.e('Error creating task: $error');
      throw Exception('Error creating task: $error');
    }
  }

  Future<List<Task>> fetchTasksByUserId(String userId) async {
    try {
      final response = await http.get(Uri.parse(updateUrl));
      if (response.statusCode == 200) {
        List<dynamic> tasksJson = jsonDecode(response.body);
        return tasksJson.map((json) => Task.fromJson(json)).toList();
      } else {
        log.e('Failed to fetch tasks: ${response.statusCode}');
        throw Exception('Failed to fetch tasks');
      }
    } catch (error) {
      log.e('Error fetching tasks: $error');
      throw Exception('Error fetching tasks: $error');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse(deleteUrl),
      );
      if (response.statusCode != 200) {
        log.e('Failed to delete task: ${response.statusCode}');
        throw Exception('Failed to delete task');
      }
    } catch (error) {
      log.e('Error deleting task: $error');
      throw Exception('Error deleting task: $error');
    }
  }
}
