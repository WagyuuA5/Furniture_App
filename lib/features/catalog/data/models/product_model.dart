import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    super.oldPrice,
    required super.stock,
    required super.description,
    required super.imageUrl,
    super.rating,
    super.sold,
    super.thumbnails,
    super.reviews,
    super.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'] ?? json['category'] ?? '1',
      price: (json['price'] as num).toDouble(),
      oldPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      stock: json['stock'],
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      sold: json['sold'] ?? 0,
      thumbnails: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
                .map((r) => ReviewModel.fromJson(r))
                .toList()
          : [],
      reviewCount: json['reviews'] != null
          ? (json['reviews'] as List).length
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'original_price': oldPrice,
      'stock': stock,
      'description': description,
      'image': imageUrl,
      'rating': rating,
      'sold': sold,
      'images': thumbnails,
      'reviews': reviews.map((r) => (r as ReviewModel).toJson()).toList(),
    };
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.userName,
    required super.comment,
    required super.rating,
    required super.timeAgo,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['user_name'] ?? json['userName'],
      comment: json['comment'],
      rating: (json['rating'] as num).toDouble(),
      timeAgo: json['time_ago'] ?? json['timeAgo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'timeAgo': timeAgo,
    };
  }
}
