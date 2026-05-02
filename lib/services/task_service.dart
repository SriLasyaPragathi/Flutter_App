import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task_model.dart';
import 'auth_service.dart';

/// Task Service - handles CRUD operations for tasks in Back4App via HTTP
class TaskService {
  static const String parseUrl = 'https://parseapi.back4app.com/parse';
  static late final String appId;
  static late final String clientKey;
  static const String className = 'Task';

  /// Initialize credentials from environment
  static Future<void> initialize() async {
    appId = AuthService.appId;
    clientKey = AuthService.clientKey;
  }

  /// Get common headers for Back4App API
  static Map<String, String> _getHeaders() {
    return {
      'X-Parse-Application-Id': appId,
      'X-Parse-Client-Key': clientKey,
      'Content-Type': 'application/json',
    };
  }

  /// Create a new task
  static Future<Task?> createTask(String title, String description) async {
    try {
      final userId = AuthService.getCurrentUserId();
      if (userId == null) {
        print('✗ User not logged in');
        return null;
      }

      final response = await http
          .post(
            Uri.parse('$parseUrl/classes/$className'),
            headers: _getHeaders(),
            body: jsonEncode({
              'title': title,
              'description': description,
              'isCompleted': false,
              'userId': userId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✓ Task created: ${data['objectId']}');
        return Task(
          id: data['objectId'],
          title: title,
          description: description,
          isCompleted: false,
        );
      } else {
        print('✗ Failed to create task: ${response.body}');
        return null;
      }
    } catch (e) {
      print('✗ Create task error: $e');
      return null;
    }
  }

  /// Fetch all tasks for the current user
  static Future<List<Task>> fetchAllTasks() async {
    try {
      final userId = AuthService.getCurrentUserId();
      if (userId == null) {
        print('✗ User not logged in');
        return [];
      }

      // Query tasks for current user, ordered by creation date
      final queryParams = {
        'where': jsonEncode({'userId': userId}),
        'order': '-createdAt',
      };

      final uri = Uri.parse(
        '$parseUrl/classes/$className',
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = (data['results'] as List)
            .map((taskData) => Task.fromJson(taskData))
            .toList();
        print('✓ Fetched ${results.length} tasks');
        return results;
      } else {
        print('✗ Failed to fetch tasks: ${response.body}');
        return [];
      }
    } catch (e) {
      print('✗ Fetch tasks error: $e');
      return [];
    }
  }

  /// Update an existing task
  static Future<bool> updateTask(
    String taskId,
    String title,
    String description,
    bool isCompleted,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$parseUrl/classes/$className/$taskId'),
            headers: _getHeaders(),
            body: jsonEncode({
              'title': title,
              'description': description,
              'isCompleted': isCompleted,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✓ Task updated: $taskId');
        return true;
      } else {
        print('✗ Failed to update task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Update task error: $e');
      return false;
    }
  }

  /// Delete a task
  static Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$parseUrl/classes/$className/$taskId'),
            headers: _getHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✓ Task deleted: $taskId');
        return true;
      } else {
        print('✗ Failed to delete task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Delete task error: $e');
      return false;
    }
  }

  /// Toggle task completion status
  static Future<bool> toggleTaskCompletion(
    String taskId,
    bool currentStatus,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$parseUrl/classes/$className/$taskId'),
            headers: _getHeaders(),
            body: jsonEncode({'isCompleted': !currentStatus}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✓ Task completion toggled: $taskId');
        return true;
      } else {
        print('✗ Failed to toggle task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Toggle task error: $e');
      return false;
    }
  }
}
