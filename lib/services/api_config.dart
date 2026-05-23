// lib/services/api_config.dart
// Semua URL endpoint sesuai furfur.json (port 3001)

import 'package:flutter/foundation.dart';

class ApiConfig {
  // ✅ Emulator Android  → pakai 10.0.2.2
  // ✅ Flutter Web / iOS Simulator → pakai localhost
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3001';
    }
    return 'http://10.0.2.2:3001';
  }

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // User & Profile
  static const String userProfile = '/user/profile';
  static const String profile     = '/profile';

  // Produk
  static const String products   = '/products';
  static const String search     = '/search';
  static const String categories = '/categories';

  // Keranjang
  static const String cart       = '/cart';
  static const String cartUpdate = '/cart/update';
  static const String cartHapus  = '/cart/hapus';

  // Pesanan
  static const String checkout     = '/checkout';
  static const String orders       = '/orders';
  static const String ordersDetail = '/orders/detail';
  static const String ordersCancel = '/orders/cancel';
}
