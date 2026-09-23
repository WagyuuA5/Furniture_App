import '../features/catalog/domain/entities/product.dart';
import '../features/catalog/domain/entities/category.dart';

class AppData {
  static final List<Category> categories = [
    const Category(id: 1, name: 'Sofa'),
    const Category(id: 2, name: 'Kursi'),
    const Category(id: 3, name: 'Lampu'),
    const Category(id: 4, name: 'Lemari'),
  ];

  static final List<Product> flashSaleProducts = [
    Product(
      id: 1,
      name: 'Sofa Minimalis Modern',
      category: 'Sofa',
      price: 2500000.0,
      oldPrice: 3200000.0,
      stock: 10,
      description:
          'Sofa minimalis dengan balutan kain kanvas berkualitas tinggi. Cocok untuk ruang tamu kecil maupun besar. Busa tebal dan tidak mudah kempes.',
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&auto=format&fit=crop',
      rating: 4.8,
      sold: 125,
      thumbnails: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1540574163026-643ea20d05b5?w=600&auto=format&fit=crop',
      ],
      reviews: [
        const Review(
          userName: 'Diana',
          comment: 'Sofa terbaik yang pernah saya beli!',
          rating: 5.0,
          timeAgo: '3 hari lalu',
        ),
        const Review(
          userName: 'Eka',
          comment: 'Nyaman banget buat santai sekeluarga.',
          rating: 4.5,
          timeAgo: '1 minggu lalu',
        ),
      ],
      reviewCount: 2,
    ),
    Product(
      id: 2,
      name: 'Modern L-Shape Sofa',
      category: 'Sofa',
      price: 3500000.0,
      oldPrice: 4000000.0,
      stock: 4,
      description:
          'Sofa bentuk L modern cocok untuk keluarga besar. Material fabric premium yang tidak mudah kotor dan sangat nyaman diduduki.',
      imageUrl:
          'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&auto=format&fit=crop',
      rating: 4.9,
      sold: 50,
      thumbnails: [
        'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&auto=format&fit=crop',
      ],
    ),
    Product(
      id: 3,
      name: 'Tempat Tidur Minimalis',
      category: 'Sofa',
      price: 1800000.0,
      stock: 12,
      description:
          'Tempat tidur minimalis yang nyaman dengan sandaran kepala beraksen tufted. Menambah kesan mewah untuk ruang tidur Anda.',
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600&auto=format&fit=crop',
      rating: 4.5,
      sold: 110,
      thumbnails: [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600&auto=format&fit=crop',
      ],
    ),
    Product(
      id: 4,
      name: 'Modern Accent Chair',
      category: 'Kursi',
      price: 600000.0,
      oldPrice: 850000.0,
      stock: 12,
      description:
          'Modern Accent Chair hadir dengan desain minimalis-modern yang memberikan kesan elegan. Sofa ini cocok digunakan untuk ruang tamu, bedroom, maupun sudut santai di rumah.',
      imageUrl:
          'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=600&auto=format&fit=crop',
      rating: 4.5,
      sold: 238,
      thumbnails: [
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=600&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=600&auto=format&fit=crop',
      ],
      reviews: [
        const Review(
          userName: 'Andi',
          comment: 'Kursi sangat nyaman dan elegan!',
          rating: 5.0,
          timeAgo: '2 hari lalu',
        ),
      ],
      reviewCount: 1,
    ),
  ];
}

final List<Product> dummyProducts = AppData.flashSaleProducts;
