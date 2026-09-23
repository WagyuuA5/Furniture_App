class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final int stock;
  final String description;
  final String imageUrl;
  double rating;
  final int sold;
  final List<String> thumbnails;
  List<Review> reviews;
  int reviewCount;

  int? get discountPercent {
    if (oldPrice == null || oldPrice == 0) return null;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.stock,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
    this.sold = 0,
    this.thumbnails = const [],
    this.reviews = const [],
    this.reviewCount = 0,
  });
}

class Review {
  final String userName;
  final String comment;
  final double rating;
  final String timeAgo;

  const Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timeAgo,
  });
}
