class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? avatar;
  final Map<String, String>? alamat;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.alamat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar'],
      alamat: json['alamat'] != null 
          ? Map<String, String>.from(json['alamat']) 
          : null,
    );
  }
}