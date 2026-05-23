import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // Ganti dengan IP server Anda
  // Untuk emulator Android: http://10.0.2.2:3000
  // Untuk device fisik: http://[IP-ANDA]:3000

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Products
  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load products');
  }

  static Future<Map<String, dynamic>> getProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load product detail');
  }

  static Future<Map<String, dynamic>> getProductReviews(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/reviews'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load reviews');
  }

  static Future<Map<String, dynamic>> addReview(
    int productId,
    int rating,
    String komentar,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/$productId/reviews'),
      headers: await _getHeaders(),
      body: json.encode({
        'rating': rating,
        'komentar': komentar,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add review');
  }

  // Categories
  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load categories');
  }

  // Cart
  static Future<Map<String, dynamic>> getCart(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart/$userId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load cart');
  }

  static Future<Map<String, dynamic>> addToCart(
    int productId,
    int jumlah,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: await _getHeaders(),
      body: json.encode({
        'productId': productId,
        'jumlah': jumlah,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add to cart');
  }

  static Future<Map<String, dynamic>> updateCartItem(
    int cartItemId,
    int jumlah,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/$cartItemId'),
      headers: await _getHeaders(),
      body: json.encode({'jumlah': jumlah}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to update cart');
  }

  static Future<Map<String, dynamic>> removeFromCart(int cartItemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$cartItemId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to remove from cart');
  }

  // Orders
  static Future<List<dynamic>> getUserOrders(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/user/$userId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load orders');
  }

  static Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load order detail');
  }

  static Future<Map<String, dynamic>> createOrder() async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to create order');
  }

  // Shipping
  static Future<List<dynamic>> getShippingOptions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/shipping/options'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load shipping options');
  }

  static Future<Map<String, dynamic>> calculateShipping(
    String kota,
    int beratKg,
    int jasaId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shipping/calculate'),
      headers: await _getHeaders(),
      body: json.encode({
        'kota': kota,
        'beratKg': beratKg,
        'jasaId': jasaId,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to calculate shipping');
  }

  // Payments
  static Future<Map<String, dynamic>> processPayment(
    String orderId,
    String metode,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: await _getHeaders(),
      body: json.encode({
        'orderId': orderId,
        'metode': metode,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to process payment');
  }

  static Future<Map<String, dynamic>> getPaymentStatus(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$orderId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to get payment status');
  }
}