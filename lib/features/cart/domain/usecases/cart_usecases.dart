import 'package:injectable/injectable.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<CartEntity> call() async {
    return await repository.getCart();
  }
}

@injectable
class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<void> call(int productId, int qty) async {
    return await repository.addToCart(productId, qty);
  }
}

@injectable
class UpdateCart {
  final CartRepository repository;

  UpdateCart(this.repository);

  Future<void> call(int cartItemId, int qty) async {
    return await repository.updateCart(cartItemId, qty);
  }
}

@injectable
class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<void> call(int cartItemId) async {
    return await repository.removeFromCart(cartItemId);
  }
}
