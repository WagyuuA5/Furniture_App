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
      final result = await AuthService.login(email, password);
      _user = result['data'];
      _role = result['role'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.register(name, email, password, phone);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _role = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      _user = await AuthService.getUser();
      _role = await AuthService.getUserRole();
    }
    notifyListeners();
  }
}