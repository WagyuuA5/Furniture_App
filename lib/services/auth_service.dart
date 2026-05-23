// lib/services/auth_service.dart
// Handle login & logout

import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'api_config.dart';

class AuthService {
  /// Login
  /// Email test  : user@example.com
  /// Password    : password123
  ///
  /// Response sukses:
  /// {
  ///   "status": "success",
  ///   "message": "Login Berhasil",
  ///   "data": {
  ///     "user_id": 1,
  ///     "nama": "User Luxe Fur",
  ///     "email": "user@example.com",
  ///     "token": "rahasia_token_123"
  ///   }
  /// }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // === VALIDASI LOKAL (Karena Mockoon tidak punya database) ===
    final prefs = await SharedPreferences.getInstance();
    final registeredEmails = prefs.getStringList('registered_emails') ?? [];
    
    // Jika email yang dimasukkan belum pernah didaftarkan di aplikasi ini
    if (!registeredEmails.contains(email)) {
      throw Exception('anda tidak punya acccount , silakan buat akun');
    }
    
    // Cek password
    final storedPassword = prefs.getString('user_password_$email');
    if (storedPassword != null && storedPassword != password) {
      throw Exception('Kata sandi salah');
    }
    
    final userName = prefs.getString('user_name_$email') ?? 'User';
    // ============================================================

    final result = await ApiClient.post(ApiConfig.login, {
      'email': email,
      'password': password,
    });
    
    // Inject local user data into result to simulate DB
    result['data'] ??= {};
    result['data']['email'] = email;
    result['data']['nama'] = userName;
    
    // Simpan token otomatis setelah login berhasil
    final token = result['data']?['token'];
    if (token != null) {
      ApiClient.setToken(token);
    }

    return result;
  }

  /// Register
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    // === SIMPAN EMAIL KE LOKAL (Agar dikenali saat login) ===
    final prefs = await SharedPreferences.getInstance();
    final registeredEmails = prefs.getStringList('registered_emails') ?? [];
    if (!registeredEmails.contains(email)) {
      registeredEmails.add(email);
      await prefs.setStringList('registered_emails', registeredEmails);
      await prefs.setString('user_name_$email', nama);
      await prefs.setString('user_password_$email', password);
    } else {
      // update password in case they re-register
      await prefs.setString('user_password_$email', password);
    }
    // ========================================================

    final result = await ApiClient.post(ApiConfig.register, {
      'nama': nama,
      'email': email,
      'password': password,
    });
    return result;
  }

  /// Logout — hapus token dari memory
  static void logout() {
    ApiClient.clearToken();
  }

  static Future<String?> getToken() async {
    // Implementasi pembacaan token jika menggunakan SharedPreferences
    // Untuk saat ini kita return null agar tidak error
    return null;
  }

  /// Change Password
  static Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('user_password_$email');
    if (storedPassword != currentPassword) {
      throw Exception('Kata sandi saat ini salah');
    }
    await prefs.setString('user_password_$email', newPassword);
    return true;
  }
}
