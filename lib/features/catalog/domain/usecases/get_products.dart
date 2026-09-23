import 'package:injectable/injectable.dart';
import '../entities/product.dart';
import '../repositories/catalog_repository.dart';

@injectable
class GetProducts {
  final CatalogRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> execute({String? category, String? keyword}) {
    return repository.getProducts(category: category, keyword: keyword);
  }
}
