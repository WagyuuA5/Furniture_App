// lib/services/order_service.dart
// Handle checkout & semua endpoint pesanan

import 'api_client.dart';
import 'api_config.dart';

class OrderService {
  /// POST /checkout — buat pesanan dari keranjang
  /// Body:
  /// {
  ///   "address": "Malang, Indonesia",
  ///   "payment_method": "transfer"
  /// }
  /// Response 200:
  /// {
  ///   "address": "Malang, Indonesia",
  ///   "payment_method": "transfer",
  ///   "message": "checkout berhasil",
  ///   "order_id": 123
  /// }
  /// Response 400: { "message": "Keranjang kosong" }
  static Future<Map<String, dynamic>> checkout({
    required String address,
    required String paymentMethod,
  }) async {
    return await ApiClient.post(ApiConfig.checkout, {
      'address': address,
      'payment_method': paymentMethod,
    });
  }

  /// GET /orders — riwayat semua pesanan
  /// Response:
  /// {
  ///   "data": [
  ///     { "id": 123, "total": 800000, "status": "pending" }
  ///   ]
  /// }
  static Future<Map<String, dynamic>> getOrders() async {
    return await ApiClient.get(ApiConfig.orders);
  }

  /// GET /orders/detail — detail satu pesanan
  /// Response:
  /// {
  ///   "data": {
  ///     "id": 123,
  ///     "products": [{ "name": "Kursi", "qty": 2, "price": 400000 }],
  ///     "total": 800000,
  ///     "status": "pending"
  ///   }
  /// }
  static Future<Map<String, dynamic>> getOrderDetail() async {
    return await ApiClient.get(ApiConfig.ordersDetail);
  }

  /// PUT /orders/cancel — batalkan pesanan
  /// Body    : { "order_id": 123 }
  /// Response 200: { "message": "Pesanan dibatalkan" }
  /// Response 400: { "message": "Pesanan tidak bisa dibatalkan" }
  static Future<Map<String, dynamic>> cancelOrder({
    required int orderId,
  }) async {
    return await ApiClient.put(ApiConfig.ordersCancel, {
      'order_id': orderId,
    });
  }
}
