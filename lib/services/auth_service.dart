// lib/services/auth_service.dart
// UPDATE:
//  - Tambah getToken() helper
//  - Tambah updateUser() untuk update profil
//  - Tambah error handling lebih detail
//  - Tambah authHeader() helper untuk request yang butuh token
//  - Konstanta baseUrl mudah diganti

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ── Ganti URL ini sesuai backend kamu ──────────────────────────────────────
  static const String baseUrl = 'http://localhost:3000';

  // ── Keys SharedPreferences ────────────────────────────────────────────────
  static const _kToken = 'token';
  static const _kUser  = 'user';
  static const _kRole  = 'role';

  // ── Header helper ─────────────────────────────────────────────────────────
  static Future<Map<String, String>> authHeader() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kToken, data['token']);
        await prefs.setString(_kUser, json.encode(data['data']));
        await prefs.setString(_kRole, data['role'] ?? 'user');
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Email atau password salah');
      } else if (response.statusCode == 404) {
        throw Exception('Akun tidak ditemukan');
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REGISTER
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return data;
      } else if (response.statusCode == 409) {
        throw Exception('Email sudah terdaftar');
      } else {
        throw Exception(data['message'] ?? 'Registrasi gagal');
      }
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    await prefs.remove(_kRole);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CEK STATUS LOGIN
  // ─────────────────────────────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken) != null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GET TOKEN
  // ─────────────────────────────────────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GET USER
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_kUser);
    if (userString != null) {
      return json.decode(userString);
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GET ROLE
  // ─────────────────────────────────────────────────────────────────────────
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UPDATE PROFIL USER (simpan lokal + kirim ke server)
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> updates) async {
    try {
      final headers = await authHeader();
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: headers,
        body: json.encode(updates),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Update cache lokal
        final current = await getUser() ?? {};
        current.addAll(updates);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kUser, json.encode(current));
        return data;
      } else {
        throw Exception(data['message'] ?? 'Gagal update profil');
      }
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REFRESH TOKEN (opsional — panggil sebelum request penting)
  // ─────────────────────────────────────────────────────────────────────────
  static Future<bool> refreshToken() async {
    try {
      final headers = await authHeader();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kToken, data['token']);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}