import '../entities/cart.dart';

abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<void> addToCart(int productId, int qty);
  Future<void> updateCart(int cartItemId, int qty);
  Future<void> removeFromCart(int cartItemId);
}
