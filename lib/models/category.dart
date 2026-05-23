class Category {
  final int id;
  final String name;
  final String icon;
  final int totalProduk;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.totalProduk,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'category',
      totalProduk: json['totalProduk'] ?? 0,
    );
  }
}