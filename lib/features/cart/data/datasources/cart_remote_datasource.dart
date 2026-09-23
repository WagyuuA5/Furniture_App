import 'package:injectable/injectable.dart';
import '../../../../services/api_client.dart';
import '../../../../services/api_config.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<void> addToCart(int productId, int qty);
  Future<void> updateCart(int cartItemId, int qty);
  Future<void> removeFromCart(int cartItemId);
}

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<CartModel> getCart() async {
    final response = await ApiClient.get(ApiConfig.cart);
    return CartModel.fromJson(response);
  }

  @override
  Future<void> addToCart(int productId, int qty) async {
    await ApiClient.post(ApiConfig.cart, {
      'product_id': productId,
      'qty': qty,
    });
  }

  @override
  Future<void> updateCart(int cartItemId, int qty) async {
    await ApiClient.put(ApiConfig.cartUpdate, {
      'product_id': cartItemId,
      'qty': qty,
    });
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    await ApiClient.delete('${ApiConfig.cartHapus}?product_id=$cartItemId');
  }
}
