import 'package:injectable/injectable.dart';
import '../../../../services/api_client.dart';
import '../../../../services/api_config.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category, String? keyword});
  Future<List<CategoryModel>> getCategories();
}

@Injectable(as: CatalogRemoteDataSource)
class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts({String? category, String? keyword}) async {
    String endpoint = ApiConfig.products;
    
    if (keyword != null && keyword.isNotEmpty) {
      endpoint = '${ApiConfig.search}?q=$keyword';
    } else if (category != null && category.isNotEmpty) {
      endpoint = '${ApiConfig.products}?category=$category';
    }

    final response = await ApiClient.get(endpoint);
    final data = response['data'] as List<dynamic>;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await ApiClient.get(ApiConfig.categories);
    final data = response['data'] as List<dynamic>;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
