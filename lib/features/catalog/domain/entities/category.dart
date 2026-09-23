class Category {
  final int id;
  final String name;
  final String icon;

  const Category({
    required this.id,
    required this.name,
    this.icon = '',
  });
}
