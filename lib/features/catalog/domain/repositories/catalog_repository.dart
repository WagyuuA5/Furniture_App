import '../entities/product.dart';
import '../entities/category.dart';

abstract class CatalogRepository {
  Future<List<Product>> getProducts({String? category, String? keyword});
  Future<Product> getProductDetail(int id);
  Future<List<Category>> getCategories();
}
