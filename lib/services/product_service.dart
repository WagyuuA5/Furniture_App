// lib/services/product_service.dart
// Handle semua endpoint produk & kategori

import 'api_client.dart';
import 'api_config.dart';

class ProductService {
  /// GET /products — semua produk
  /// Response:
  /// {
  ///   "message": "Berhasil ambil data",
  ///   "data": [
  ///     { "id": 1, "name": "Modern Accent Chair", "price": 400000, "category": "Kursi", "stock": 10 },
  ///     { "id": 2, "name": "Sofa Minimalis",      "price": 550000, "category": "Sofa",  "stock": 10 },
  ///     ...
  ///   ]
  /// }
  static Future<Map<String, dynamic>> getAll() async {
    return await ApiClient.get(ApiConfig.products);
  }

  /// GET /products/details — detail produk
  /// Response:
  /// {
  ///   "data": {
  ///     "id": 1,
  ///     "name": "Modern Accent Chair",
  ///     "price": 400000,
  ///     "description": "Kursi nyaman",
  ///     "stock": 10
  ///   }
  /// }
  static Future<Map<String, dynamic>> getDetail() async {
    return await ApiClient.get('${ApiConfig.products}/details');
  }

  /// GET /products?category=kursi — filter by kategori
  /// Contoh: getByCategory('kursi')
  static Future<Map<String, dynamic>> getByCategory(String category) async {
    return await ApiClient.get('${ApiConfig.products}?category=$category');
  }

  /// GET /search?q=sofa — cari produk
  /// Contoh: search('sofa')
  static Future<Map<String, dynamic>> search(String keyword) async {
    return await ApiClient.get('${ApiConfig.search}?q=$keyword');
  }

  /// GET /categories — semua kategori
  /// Response:
  /// {
  ///   "data": [
  ///     { "id": 1, "name": "kursi" },
  ///     { "id": 2, "name": "sofa" },
  ///     { "id": 3, "name": "meja" },
  ///     { "id": 4, "name": "Lampu" }
  ///   ]
  /// }
  static Future<Map<String, dynamic>> getCategories() async {
    return await ApiClient.get(ApiConfig.categories);
  }
}
