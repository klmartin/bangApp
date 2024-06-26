import 'dart:convert';
import 'package:bangapp/constants/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  int? _userId;
  String? _userName;
  String? _userImage;
  bool _isAuthenticated = false;

  String get token => _token ?? '';
  int? get userId => _userId;
  String? get userName => _userName;
  String? get userImage => _userImage;

  bool get isAuthenticated => _token != null;
  bool get isAuthenticatedd => _isAuthenticated;

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _saveUserData(responseData);
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await _saveUserData(responseData);
        _isAuthenticated = true;
      } else {
        final responseData = json.decode(response.body);
        throw Exception('Login failed: ${responseData['message']}');
      }
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }

  /// Saves user data to local storage and updates provider state
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    _token = data['token'];
    _userId = data['user_id'];
    _userName = data['name'];
    _userImage = data['user_image'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setInt('user_id', _userId ?? 0);
    await prefs.setString('user_name', _userName ?? '');
    await prefs.setString('user_image', _userImage ?? '');

    notifyListeners();
  }

  // Future<void> autoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _token = prefs.getString('token');
  //   _userId = prefs.getInt('user_id');
  //   _userName = prefs.getString('user_name');
  //   _userImage = prefs.getString('user_image');

  //   notifyListeners();
  // }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _userId = null;
    _userName = null;
    _userImage = null;

    notifyListeners();
  }
}
