// lib/services/cart_service.dart
// Handle semua endpoint keranjang belanja

import 'api_client.dart';
import 'api_config.dart';

class CartService {
  /// GET /cart — ambil isi keranjang
  /// Response:
  /// {
  ///   "data": [
  ///     { "id": 1, "product_id": 1, "name": "Kursi", "qty": 2, "price": 400000 }
  ///   ]
  /// }
  static Future<Map<String, dynamic>> getCart() async {
    return await ApiClient.get(ApiConfig.cart);
  }

  /// POST /cart — tambah produk ke keranjang
  /// Body    : { "product_id": 1, "qty": 2 }
  /// Response 201: { "product_id": 1, "qty": 2, "message": "Berhasil masuk ke keranjang" }
  /// Response 400: { "message": "Stok tidak cukup" }
  static Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int qty,
  }) async {
    return await ApiClient.post(ApiConfig.cart, {
      'product_id': productId,
      'qty': qty,
    });
  }

  /// PUT /cart/update — update jumlah item
  /// Body    : { "product_id": 1, "qty": 3 }
  /// Response: { "qty": 3, "message": "Jumlah berhasil diupdate" }
  static Future<Map<String, dynamic>> updateCart({
    required int productId,
    required int qty,
  }) async {
    return await ApiClient.put(ApiConfig.cartUpdate, {
      'product_id': productId,
      'qty': qty,
    });
  }

  /// DELETE /cart/hapus — hapus item dari keranjang
  /// Body    : { "product_id": 1 }
  /// Response: { "message": "Item dihapus dari keranjang" }
  static Future<Map<String, dynamic>> removeFromCart({
    required int productId,
  }) async {
    return await ApiClient.delete(
      '${ApiConfig.cartHapus}?product_id=$productId',
    );
  }
}
