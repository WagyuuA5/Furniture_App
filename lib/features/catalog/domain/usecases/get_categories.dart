import 'package:injectable/injectable.dart';
import '../entities/category.dart';
import '../repositories/catalog_repository.dart';

@injectable
class GetCategories {
  final CatalogRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> execute() {
    return repository.getCategories();
  }
}
