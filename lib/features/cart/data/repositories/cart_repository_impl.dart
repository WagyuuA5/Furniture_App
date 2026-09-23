import 'package:injectable/injectable.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<CartEntity> getCart() async {
    return await remoteDataSource.getCart();
  }

  @override
  Future<void> addToCart(int productId, int qty) async {
    await remoteDataSource.addToCart(productId, qty);
  }

  @override
  Future<void> updateCart(int cartItemId, int qty) async {
    await remoteDataSource.updateCart(cartItemId, qty);
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    await remoteDataSource.removeFromCart(cartItemId);
  }
}
