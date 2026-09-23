import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../features/cart/domain/entities/cart.dart';
import '../features/cart/domain/usecases/cart_usecases.dart';

@injectable
class CartProvider extends ChangeNotifier {
  final GetCart getCartUseCase;
  final AddToCart addToCartUseCase;
  final UpdateCart updateCartUseCase;
  final RemoveFromCart removeFromCartUseCase;

  CartEntity? _cart;
  bool _isLoading = false;

  CartProvider({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartUseCase,
    required this.removeFromCartUseCase,
  });

  CartEntity? get cart => _cart;
  bool get isLoading => _isLoading;

  List<CartItemEntity> get items => _cart?.items ?? [];
  int get totalCount =>
      _cart?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;
  bool get isEmpty => items.isEmpty;

  double getTotalPrice() =>
      _cart?.items.fold<double>(0.0, (sum, i) => sum + i.totalPrice) ?? 0.0;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cart = await getCartUseCase();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(int productId, int quantity) async {
    try {
      await addToCartUseCase(productId, quantity);
      await loadCart();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> updateQuantity(int cartItemId, int delta) async {
    final idx = items.indexWhere((e) => e.cartItemId == cartItemId);
    if (idx < 0) return;

    final newQty = items[idx].quantity + delta;
    if (newQty < 1) return;

    try {
      await updateCartUseCase(cartItemId, newQty);
      await loadCart();
    } catch (e) {
      debugPrint('Error updating cart: $e');
    }
  }

  Future<void> removeItem(int cartItemId) async {
    try {
      await removeFromCartUseCase(cartItemId);
      await loadCart();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  void clear() {
    _cart = null;
    notifyListeners();
  }
}
