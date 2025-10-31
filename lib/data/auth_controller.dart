import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_models.dart';

class AuthController {
  static String? _token;
  static UserModel? _user;

  static String? get token => _token;
  static UserModel? get user => _user;

  static Future<void> saveUserInformation(String t, UserModel m) async {
    _token = t;
    _user = m;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', t);
    await prefs.setString('user', jsonEncode(m.toJson()));
  }

  static Future<void> updateUserInformation(UserModel m) async {
    _user = m;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(m.toJson()));
  }

  static Future<void> initializeUserCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  static Future<bool> isLoggedIn() async {
    await initializeUserCache();
    return _token != null;
  }

  static Future<void> clearAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _user = null;
  }
}