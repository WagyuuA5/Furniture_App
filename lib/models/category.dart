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
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      totalProduk: json['totalProduk'],
    );
  }
}