import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _role;
  bool _isLoading = false;

  Map<String, dynamic>? get user => _user;
  String? get role => _role;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.login(email: email, password: password);
      _user = result['data'];
      _role = result['role'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> register(String name, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.register(
        nama: name,
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    AuthService.logout();
    _user = null;
    _role = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      // Decode user from token or API if needed, for now just flag as true
      _user = {'token': token};
    }
    notifyListeners();
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_user == null || _user!['email'] == null) {
      throw Exception('Sesi tidak valid, silakan login kembali');
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.changePassword(
        email: _user!['email'],
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}