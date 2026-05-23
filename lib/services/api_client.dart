import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.get(url, headers: _headers);
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, [Map<String, dynamic>? body]) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint, [Map<String, dynamic>? body]) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.put(
      url,
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final response = await http.delete(url, headers: _headers);
    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Terjadi kesalahan (Code: ${response.statusCode})');
      }
    } catch (e) {
      if (e is FormatException) {
        // Jika response bukan JSON (misal HTML 404 dari Mockoon)
        if (response.statusCode == 404) {
          throw Exception('Endpoint tidak ditemukan (404). Pastikan Anda sudah membuat endpoint di Mockoon.');
        }
        throw Exception('Server error (Code: ${response.statusCode}): Respons bukan JSON valid.');
      }
      rethrow;
    }
  }
}