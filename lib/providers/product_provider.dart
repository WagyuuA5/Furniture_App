import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../features/catalog/domain/entities/product.dart';
import '../features/catalog/domain/entities/category.dart';
import '../features/catalog/domain/usecases/get_products.dart';
import '../features/catalog/domain/usecases/get_categories.dart';

@injectable
class ProductProvider with ChangeNotifier {
  final GetProducts _getProducts;
  final GetCategories _getCategories;

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;

  ProductProvider(this._getProducts, this._getCategories);

  List<Product> get products => _filteredProducts;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Product> get _filteredProducts {
    var filtered = _products;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _getProducts.execute();
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _getCategories.execute();
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
