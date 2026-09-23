import 'package:injectable/injectable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_datasource.dart';

@Injectable(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts({String? category, String? keyword}) async {
    return await remoteDataSource.getProducts(
      category: category,
      keyword: keyword,
    );
  }

  @override
  Future<Product> getProductDetail(int id) {
    throw UnimplementedError('Not used in current implementation');
  }

  @override
  Future<List<Category>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
