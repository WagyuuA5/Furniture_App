import '../../domain/entities/cart.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.cartItemId,
    required super.productId,
    required super.name,
    required super.category,
    required super.imageUrl,
    required super.pricePerUnit,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cartItemId'] ?? json['id'] ?? 0,
      productId: json['productId'] ?? json['product_id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '', // Fallback for missing category
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      pricePerUnit: (json['harga'] ?? json['price'] ?? 0).toDouble(),
      quantity: json['jumlah'] ?? json['qty'] ?? 1,
    );
  }
}

class CartModel extends CartEntity {
  CartModel({
    required super.userId,
    required super.totalItem,
    required super.totalHarga,
    required super.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'] ?? 1, // Fallback if missing
      totalItem: json['totalItem'] ?? 0,
      totalHarga: (json['totalHarga'] ?? 0).toDouble(),
      items: (json['items'] ?? json['data'] ?? [])
          .map<CartItemModel>((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }
}
