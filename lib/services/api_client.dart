import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../core/local_storage.dart';

class ApiClient {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Future<Map<String, String>> _headers({bool needAuth = false}) async {
    final ownerToken = await LocalStorage.getOwnerToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'app-key': ownerToken ?? '',
    };

    if (needAuth) {
      final authToken = await LocalStorage.getAuthToken();
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      } else if (_token != null && _token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_token'; // Fallback just in case
      }
    }

    return headers;
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool needAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.get(
      url,
      headers: await _headers(needAuth: needAuth),
    );
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.post(
      url,
      headers: await _headers(needAuth: needAuth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.put(
      url,
      headers: await _headers(needAuth: needAuth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool needAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.delete(
      url,
      headers: await _headers(needAuth: needAuth),
    );
    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw Exception(
          decoded['message'] ??
              'Terjadi kesalahan (Code: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        // Jika response bukan JSON (misal HTML 404 dari Mockoon)
        if (response.statusCode == 404) {
          throw Exception(
            'Endpoint tidak ditemukan (404). Pastikan Anda sudah membuat endpoint di Mockoon.',
          );
        }
        throw Exception(
          'Server error (Code: ${response.statusCode}): Respons bukan JSON valid.',
        );
      }
      rethrow;
    }
  }
}
