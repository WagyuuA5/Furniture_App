class CartItemEntity {
  final int cartItemId;
  final int productId;
  final String name;
  final String category;
  final String imageUrl;
  final double pricePerUnit;
  int quantity;

  CartItemEntity({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.pricePerUnit,
    required this.quantity,
  });

  double get totalPrice => pricePerUnit * quantity;
}

class CartEntity {
  final int userId;
  final int totalItem;
  final double totalHarga;
  final List<CartItemEntity> items;

  CartEntity({
    required this.userId,
    required this.totalItem,
    required this.totalHarga,
    required this.items,
  });
}
