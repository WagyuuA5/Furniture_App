import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  CartData? _cart;
  bool _isLoading = false;

  CartData? get cart => _cart;
  bool get isLoading => _isLoading;
  int get totalItems => _cart?.totalItem ?? 0;
  int get totalPrice => _cart?.totalHarga ?? 0;

  Future<void> loadCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getCart(userId);
      _cart = CartData.fromJson(data);
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, int jumlah) async {
    try {
      await ApiService.addToCart(productId, jumlah);
      if (_cart != null) {
        await loadCart(_cart!.userId);
      }
      return true;
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> updateQuantity(int cartItemId, int jumlah) async {
    try {
      await ApiService.updateCartItem(cartItemId, jumlah);
      if (_cart != null) {
        await loadCart(_cart!.userId);
      }
      return true;
    } catch (e) {
      debugPrint('Error updating cart: $e');
      return false;
    }
  }

  Future<bool> removeItem(int cartItemId) async {
    try {
      await ApiService.removeFromCart(cartItemId);
      if (_cart != null) {
        await loadCart(_cart!.userId);
      }
      return true;
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      return false;
    }
  }

  void clearCart() {
    _cart = null;
    notifyListeners();
  }
}