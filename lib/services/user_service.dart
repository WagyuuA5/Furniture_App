// lib/services/user_service.dart
// Handle profil user

import 'api_client.dart';
import 'api_config.dart';

class UserService {
  /// GET /user/profile
  /// Response:
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "id": 1,
  ///     "nama_user": "Bubud",
  ///     "username": "@bubud",
  ///     "email": "bubud@gmail.com",
  ///     "no_telp": "08198765432"
  ///   }
  /// }
  static Future<Map<String, dynamic>> getUserProfile() async {
    return await ApiClient.get(ApiConfig.userProfile);
  }

  /// GET /profile
  /// Response:
  /// {
  ///   "data": {
  ///     "name": "Bubud",
  ///     "email": "bubud@gmail.com"
  ///   }
  /// }
  static Future<Map<String, dynamic>> getProfile() async {
    return await ApiClient.get(ApiConfig.profile);
  }

  /// PUT /profile
  /// Body  : { "name": "...", "address": "..." }
  /// Response:
  /// {
  ///   "name": "Bintang Update",
  ///   "address": "Malang",
  ///   "message": "Profil berhasil diupdate"
  /// }
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String address,
  }) async {
    return await ApiClient.put(ApiConfig.profile, {
      'name': name,
      'address': address,
    });
  }
}
