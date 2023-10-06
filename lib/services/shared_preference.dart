import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setUsername(String username) async {
    await _prefs.setString('username', username);
  }

  static String getUsername() {
    return _prefs.getString('username') ?? '';
  }

  static Future<void> setIsAdmin(bool isAdmin) async {
    await _prefs.setBool('isAdmin', isAdmin);
  }

  static bool isAdmin() {
    return _prefs.getBool('isAdmin') ?? false;
  }

  static Future<void> clearUserData() async {
    await _prefs.remove('isLoggedIn');
    await _prefs.remove('username');
    await _prefs.remove('isAdmin');
  }
  
}
