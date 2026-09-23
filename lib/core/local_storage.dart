import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _ownerTokenKey = 'owner_token';
  static const String _authTokenKey = 'auth_token';

  static Future<void> saveOwnerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownerTokenKey, token);
  }

  static Future<String?> getOwnerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ownerTokenKey);
  }

  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }
}
