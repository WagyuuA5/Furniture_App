import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;

  List<Product> get products => _filteredProducts;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Product> get _filteredProducts {
    var filtered = _products;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    if (_selectedCategory != null) {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    
    return filtered;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ProductService.getAll();
      final data = response['data'] as List<dynamic>;
      _products = data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await ProductService.getCategories();
      final data = response['data'] as List<dynamic>;
      _categories = data.map((json) => Category.fromJson(json)).toList();
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