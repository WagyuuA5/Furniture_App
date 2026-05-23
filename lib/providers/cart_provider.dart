import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

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
      final data = await CartService.getCart();
      // Kalau response cuma satu object seperti di Mockoon, 
      // kita harus merakitnya menjadi format yang diharapkan model
      // atau membiarkannya sesuai model CartData.
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
      await CartService.addToCart(productId: productId, qty: jumlah);
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
      // updateCart expects productId in CartService, but here we only have cartItemId.
      // We will pass cartItemId as productId for now to match Mockoon structure.
      await CartService.updateCart(productId: cartItemId, qty: jumlah);
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
      await CartService.removeFromCart(productId: cartItemId);
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