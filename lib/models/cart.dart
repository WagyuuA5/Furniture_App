class CartItem {
  final int cartItemId;
  final int productId;
  final String name;
  final String image;
  final int harga;
  int jumlah;
  final int subtotal;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.harga,
    required this.jumlah,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      subtotal: json['subtotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'name': name,
      'image': image,
      'harga': harga,
      'jumlah': jumlah,
      'subtotal': subtotal,
    };
  }
}

class CartData {
  final int userId;
  final int totalItem;
  final int totalHarga;
  final List<CartItem> items;

  CartData({
    required this.userId,
    required this.totalItem,
    required this.totalHarga,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      userId: json['userId'],
      totalItem: json['totalItem'],
      totalHarga: json['totalHarga'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}