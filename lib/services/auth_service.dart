import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Authentication Service - handles login, register, and logout with Back4App via HTTP
class AuthService {
  static const String parseUrl = 'https://parseapi.back4app.com/parse';
  static late final String appId;
  static late final String clientKey;

  /// Initialize credentials from environment
  static Future<void> initialize() async {
    appId = dotenv.env['PARSE_APP_ID'] ?? '';
    clientKey = dotenv.env['PARSE_CLIENT_KEY'] ?? '';
    if (appId.isEmpty || clientKey.isEmpty) {
      throw Exception('Missing PARSE_APP_ID or PARSE_CLIENT_KEY in .env file');
    }
  }

  static String? _currentUserId;
  static String? _currentEmail;
  static String? _sessionToken;

  /// Get common headers for Back4App API
  static Map<String, String> _getHeaders() {
    return {
      'X-Parse-Application-Id': appId,
      'X-Parse-Client-Key': clientKey,
      'Content-Type': 'application/json',
      if (_sessionToken != null) 'X-Parse-Session-Token': _sessionToken!,
    };
  }

  /// Register a new user with email and password
  static Future<bool> register(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$parseUrl/users'),
            headers: _getHeaders(),
            body: jsonEncode({
              'username': email,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _currentUserId = data['objectId'];
        _currentEmail = email;
        _sessionToken = data['sessionToken'];
        print('✓ Registration successful');
        return true;
      } else {
        print('✗ Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Registration error: $e');
      return false;
    }
  }

  /// Login user with email and password
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$parseUrl/login'),
            headers: _getHeaders(),
            body: jsonEncode({'username': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUserId = data['objectId'];
        _currentEmail = email;
        _sessionToken = data['sessionToken'];
        print('✓ Login successful');
        return true;
      } else {
        print('✗ Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Login error: $e');
      return false;
    }
  }

  /// Get currently logged-in user
  static Future<bool> isLoggedIn() async {
    return _sessionToken != null && _currentUserId != null;
  }

  /// Get current user's ID
  static String? getCurrentUserId() {
    return _currentUserId;
  }

  /// Logout the current user
  static Future<bool> logout() async {
    try {
      if (_sessionToken == null) {
        print('✓ User already logged out');
        _currentUserId = null;
        _currentEmail = null;
        _sessionToken = null;
        return true;
      }

      final response = await http
          .post(Uri.parse('$parseUrl/logout'), headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✓ Logout successful');
        _currentUserId = null;
        _currentEmail = null;
        _sessionToken = null;
        return true;
      } else {
        print('✗ Logout failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('✗ Logout error: $e');
      _currentUserId = null;
      _currentEmail = null;
      _sessionToken = null;
      return true; // Clear session anyway
    }
  }

  /// Get the current user's email
  static Future<String?> getCurrentUserEmail() async {
    return _currentEmail;
  }
}
