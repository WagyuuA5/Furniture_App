// models/product_model.dart
// Berisi:
//  1. Review class
//  2. Model asli user  → Product, ProductReview
//  3. Adapter layer    → ProductModel (wrapper tipis ke Product), CategoryModel, AppData
//  4. dummyProducts    → data dummy untuk ProductListScreen

// ─────────────────────────────────────────────────────────────────────────────
// 0. REVIEW CLASS (dipakai oleh ProductModel, RatingScreen, LeaveReviewScreen)
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// 1. MODEL ASLI
// ─────────────────────────────────────────────────────────────────────────────

class Product {
  final int id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final String description;
  final String image;
  double rating;
  final int sold;
  final int? originalPrice;
  final List<String>? images;
  final Map<String, String>? specs;

  // ── Mutable review data ──
  List<Review> reviews;
  int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
    required this.rating,
    required this.sold,
    this.originalPrice,
    this.images,
    this.specs,
    List<Review>? reviews,
    int? reviewCount,
  })  : reviews = reviews ?? [],
        reviewCount = reviewCount ?? (reviews?.length ?? 0);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      stock: json['stock'],
      description: json['description'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      sold: json['sold'],
      originalPrice: json['originalPrice'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      specs: json['specs'] != null
          ? Map<String, String>.from(json['specs'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
      'image': image,
      'rating': rating,
      'sold': sold,
      'originalPrice': originalPrice,
      'images': images,
      'specs': specs,
    };
  }
}

class ProductReview {
  final int id;
  final int userId;
  final String nama;
  final int rating;
  final String komentar;
  final String tanggal;

  const ProductReview({
    required this.id,
    required this.userId,
    required this.nama,
    required this.rating,
    required this.komentar,
    required this.tanggal,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      userId: json['userId'],
      nama: json['nama'],
      rating: json['rating'],
      komentar: json['komentar'],
      tanggal: json['tanggal'],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. ADAPTER LAYER — memetakan field Product ke nama yang dipakai widget
// ─────────────────────────────────────────────────────────────────────────────

class ProductModel {
  final Product _p;

  const ProductModel(this._p);

  String get id          => _p.id.toString();
  String get name        => _p.name;
  String get description => _p.description;
  double get price       => _p.price.toDouble();
  double get rating      => _p.rating;
  set rating(double v)   => _p.rating = v;
  int    get reviewCount => _p.reviewCount;
  set reviewCount(int v) => _p.reviewCount = v;
  String get categoryId  => _p.category;
  String get category    => _p.category;
  int    get stock       => _p.stock;

  String get imageUrl => _p.image;

  List<String> get thumbnails =>
      (_p.images != null && _p.images!.isNotEmpty) ? _p.images! : [_p.image];

  double? get oldPrice =>
      _p.originalPrice != null ? _p.originalPrice!.toDouble() : null;

  int? get discountPercent {
    if (_p.originalPrice == null || _p.originalPrice! <= _p.price) return null;
    return ((_p.originalPrice! - _p.price) / _p.originalPrice! * 100).round();
  }

  // ── Review proxies ──
  List<Review> get reviews => _p.reviews;
  set reviews(List<Review> v) => _p.reviews = v;

  /// Akses ke object Product asli jika diperlukan.
  Product get raw => _p;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CATEGORY MODEL
// ─────────────────────────────────────────────────────────────────────────────

class CategoryModel {
  final String id;
  final String name;
  final String icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. SEED DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppData {
  AppData._();

  static const List<CategoryModel> categories = [
    CategoryModel(id: 'sofa',     name: 'Sofa',   icon: 'sofa'),
    CategoryModel(id: 'chair',    name: 'Kursi',  icon: 'chair'),
    CategoryModel(id: 'lamp',     name: 'Lampu',  icon: 'lamp'),
    CategoryModel(id: 'wardrobe', name: 'Lemari', icon: 'wardrobe'),
  ];

  static final List<ProductModel> flashSaleProducts =
      _rawProducts.map((p) => ProductModel(p)).toList();

  static final List<Product> _rawProducts = [
    // ── SOFA ──
    Product(
      id: 1,
      name: 'Scandinavian Sofa',
      category: 'Sofa',
      price: 1200000,
      originalPrice: 1500000,
      stock: 7,
      description:
          'Sofa bergaya Scandinavian dengan rangka kayu solid dan busa high-density. '
          'Cocok untuk ruang tamu modern dengan nuansa hangat dan minimalis.',
      image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&auto=format&fit=crop',
      rating: 4.8,
      sold: 182,
      images: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&auto=format&fit=crop',
      ],
      reviews: [
        const Review(userName: 'Diana', comment: 'Sofa terbaik yang pernah saya beli!', rating: 5.0, timeAgo: '3 hari lalu'),
        const Review(userName: 'Eka', comment: 'Nyaman banget buat santai sekeluarga.', rating: 4.5, timeAgo: '1 minggu lalu'),
      ],
    ),
    Product(
      id: 2,
      name: 'Modern L-Shape Sofa',
      category: 'Sofa',
      price: 3500000,
      originalPrice: 4000000,
      stock: 4,
      description: 'Sofa bentuk L modern cocok untuk keluarga besar. Material fabric premium yang tidak mudah kotor dan sangat nyaman diduduki.',
      image: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&auto=format&fit=crop',
      rating: 4.9,
      sold: 50,
      images: ['https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&auto=format&fit=crop'],
    ),
    Product(
      id: 3,
      name: 'Sofa Minimalis 2 Seater',
      category: 'Sofa',
      price: 1800000,
      stock: 12,
      description: 'Sofa minimalis 2 seater cocok untuk apartemen atau ruangan kecil. Kaki terbuat dari kayu jati belanda yang kokoh.',
      image: 'https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=600&auto=format&fit=crop',
      rating: 4.5,
      sold: 110,
      images: ['https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=600&auto=format&fit=crop'],
    ),
    // ── KURSI ──
    Product(
      id: 4,
      name: 'Modern Accent Chair',
      category: 'Kursi',
      price: 600000,
      originalPrice: 850000,
      stock: 12,
      description:
          'Modern Accent Chair hadir dengan desain minimalis-modern yang memberikan kesan elegan. '
          'Sofa ini cocok digunakan untuk ruang tamu, bedroom, maupun sudut santai di rumah.',
      image: 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=600&auto=format&fit=crop',
      rating: 4.5,
      sold: 238,
      images: [
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=600&auto=format&fit=crop',
      ],
      reviews: [
        const Review(userName: 'Andi', comment: 'Kursi sangat nyaman dan elegan!', rating: 5.0, timeAgo: '2 hari lalu'),
      ],
    ),
    Product(
      id: 5,
      name: 'Kursi Makan Kayu Jati',
      category: 'Kursi',
      price: 450000,
      stock: 25,
      description: 'Kursi makan dengan material kayu jati asli, finishing halus dan tahan lama. Desain punggung melengkung untuk kenyamanan maksimal.',
      image: 'https://images.unsplash.com/photo-1503602642458-232111445657?w=600&auto=format&fit=crop',
      rating: 4.7,
      sold: 340,
      images: ['https://images.unsplash.com/photo-1503602642458-232111445657?w=600&auto=format&fit=crop'],
    ),
    Product(
      id: 6,
      name: 'Office Chair Ergonomis',
      category: 'Kursi',
      price: 1250000,
      originalPrice: 1500000,
      stock: 8,
      description: 'Kursi kantor ergonomis dengan fitur penyesuaian tinggi dan kemiringan punggung. Bantalan jaring (mesh) yang tidak membuat panas saat duduk lama.',
      image: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?w=600&auto=format&fit=crop',
      rating: 4.9,
      sold: 120,
      images: ['https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?w=600&auto=format&fit=crop'],
    ),
    // ── LAMPU ──
    Product(
      id: 7,
      name: 'Lampu Gantung Industrial',
      category: 'Lampu',
      price: 685000,
      stock: 20,
      description:
          'Lampu gantung bergaya industrial dengan material besi hitam matte. '
          'Memberikan nuansa hangat dan elegan untuk ruang makan atau dapur.',
      image: 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=600&auto=format&fit=crop',
      rating: 4.5,
      sold: 95,
      images: [
        'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=600&auto=format&fit=crop',
      ],
      reviews: [
        const Review(userName: 'Fajar', comment: 'Lampu bagus, pencahayaan pas.', rating: 4.0, timeAgo: '5 hari lalu'),
      ],
    ),
    Product(
      id: 8,
      name: 'Lampu Meja Belajar LED',
      category: 'Lampu',
      price: 250000,
      originalPrice: 300000,
      stock: 45,
      description: 'Lampu meja minimalis dengan lampu LED yang dapat diatur tingkat kecerahannya. Baterai tahan lama dan bisa di-charge menggunakan USB.',
      image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600&auto=format&fit=crop',
      rating: 4.6,
      sold: 450,
      images: ['https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600&auto=format&fit=crop'],
    ),
    Product(
      id: 9,
      name: 'Standing Lamp Aesthetic',
      category: 'Lampu',
      price: 850000,
      stock: 15,
      description: 'Lampu berdiri sudut ruangan dengan kap lampu berbahan kain linen. Menciptakan suasana ruangan yang hangat dan aesthetic di malam hari.',
      image: 'https://images.unsplash.com/photo-1513506003901-1e6a229e9d15?w=600&auto=format&fit=crop',
      rating: 4.8,
      sold: 76,
      images: ['https://images.unsplash.com/photo-1513506003901-1e6a229e9d15?w=600&auto=format&fit=crop'],
    ),
    // ── LEMARI ──
    Product(
      id: 10,
      name: 'Lemari Pakaian 3 Pintu',
      category: 'Lemari',
      price: 3200000,
      originalPrice: 3900000,
      stock: 5,
      description:
          'Lemari pakaian tiga pintu dengan cermin di pintu tengah. '
          'Material MDF dilapisi HPL motif kayu dengan engsel soft-close.',
      image: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=600&auto=format&fit=crop',
      rating: 4.7,
      sold: 61,
      images: [
        'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=600&auto=format&fit=crop',
      ],
    ),
    Product(
      id: 11,
      name: 'Rak Buku Minimalis',
      category: 'Lemari',
      price: 1100000,
      stock: 18,
      description: 'Rak buku dengan desain terbuka dan rak melayang, cocok untuk menyimpan buku dan pajangan ruang tamu. Rangka besi yang kokoh dipadukan dengan ambalan kayu asli.',
      image: 'https://images.unsplash.com/photo-1594026112284-02bb6f3352fe?w=600&auto=format&fit=crop',
      rating: 4.9,
      sold: 210,
      images: ['https://images.unsplash.com/photo-1594026112284-02bb6f3352fe?w=600&auto=format&fit=crop'],
    ),
    Product(
      id: 12,
      name: 'Lemari Laci Kabinet',
      category: 'Lemari',
      price: 1850000,
      originalPrice: 2000000,
      stock: 9,
      description: 'Kabinet laci kayu susun 4, sangat fungsional untuk menyimpan barang-barang kecil agar rumah terlihat rapi dan terorganisir.',
      image: 'https://images.unsplash.com/photo-1558997519-83ea9252edf8?w=600&auto=format&fit=crop',
      rating: 4.6,
      sold: 88,
      images: ['https://images.unsplash.com/photo-1558997519-83ea9252edf8?w=600&auto=format&fit=crop'],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. DUMMY PRODUCTS (untuk ProductListScreen)
// ─────────────────────────────────────────────────────────────────────────────

/// Global list of dummy products used by ProductListScreen.
final List<ProductModel> dummyProducts = AppData.flashSaleProducts;