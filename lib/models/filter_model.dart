// models/filter_model.dart
// Model untuk filter produk – digunakan oleh FilterScreen & ProductListScreen

class FilterModel {
  String category;
  double minPrice;
  double maxPrice;
  String reviewRange;
  String sortBy;
  String room;

  FilterModel({
    this.category = 'All',
    this.minPrice = 50,
    this.maxPrice = 400,
    this.reviewRange = '',
    this.sortBy = 'All',
    this.room = 'All',
  });

  /// Rating minimum berdasarkan reviewRange string
  double get minRating {
    switch (reviewRange) {
      case '4.5 and above':
        return 4.5;
      case '4.0 - 4.5':
        return 4.0;
      case '3.5 - 4.0':
        return 3.5;
      case '3.0 - 3.5':
        return 3.0;
      case '2.5 - 3.0':
        return 2.5;
      default:
        return 0;
    }
  }

  /// Rating maksimum berdasarkan reviewRange string
  double get maxRating {
    switch (reviewRange) {
      case '4.5 and above':
        return 5.0;
      case '4.0 - 4.5':
        return 4.5;
      case '3.5 - 4.0':
        return 4.0;
      case '3.0 - 3.5':
        return 3.5;
      case '2.5 - 3.0':
        return 3.0;
      default:
        return 5.0;
    }
  }

  FilterModel copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? reviewRange,
    String? sortBy,
    String? room,
  }) {
    return FilterModel(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      reviewRange: reviewRange ?? this.reviewRange,
      sortBy: sortBy ?? this.sortBy,
      room: room ?? this.room,
    );
  }

  void reset() {
    category = 'All';
    minPrice = 50;
    maxPrice = 400;
    reviewRange = '';
    sortBy = 'All';
    room = 'All';
  }
}
