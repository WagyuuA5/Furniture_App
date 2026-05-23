// lib/models/order_model.dart
//
// Satu file untuk semua model order di LUXE FURNISH:
//  - OrderItem      → item di dalam pesanan (dengan fromJson)
//  - Order          → pesanan lengkap dari API (dengan fromJson)
//  - OrderSummary   → ringkasan untuk PaymentSuccessScreen & StrukPembayaranScreen
//  - fmtRp()        → format Rupiah  "Rp180.000"
//  - fmtDate()      → format tanggal "Sep, 8, 2026 | 13.00"

// ─────────────────────────────────────────────
// OrderItem  (dipakai Order & OrderSummary)
// ─────────────────────────────────────────────
class OrderItem {
  final int productId;
  final String name;
  final String category;   // ← ditambah untuk UI card
  final String imageUrl;   // ← ditambah untuk UI card
  final int jumlah;
  final int harga;

  const OrderItem({
    required this.productId,
    required this.name,
    this.category = '',    // default kosong agar fromJson lama tetap valid
    this.imageUrl = '',    // default kosong agar fromJson lama tetap valid
    required this.jumlah,
    required this.harga,
  });

  // ── Dari JSON API ──────────────────────────
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as int,
      name: json['name'] as String,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      jumlah: json['jumlah'] as int,
      harga: json['harga'] as int,
    );
  }

  // ── Ke JSON ───────────────────────────────
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'jumlah': jumlah,
        'harga': harga,
      };

  // Harga total item ini
  int get totalHargaItem => harga * jumlah;

  // ── Alias getters for UI compatibility ──
  double get price => harga.toDouble();
  int get quantity => jumlah;
}

// ─────────────────────────────────────────────
// Order  (model utama dari API)
// ─────────────────────────────────────────────
class Order {
  final String orderId;
  final String status;
  final int totalHarga;
  final String tanggalPesan;
  final String? tanggalKirim;
  final List<OrderItem> items;

  const Order({
    required this.orderId,
    required this.status,
    required this.totalHarga,
    required this.tanggalPesan,
    this.tanggalKirim,
    required this.items,
  });

  // ── Dari JSON API ──────────────────────────
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      totalHarga: json['totalHarga'] as int,
      tanggalPesan: json['tanggalPesan'] as String,
      tanggalKirim: json['tanggalKirim'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // ── Ke JSON ───────────────────────────────
  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'status': status,
        'totalHarga': totalHarga,
        'tanggalPesan': tanggalPesan,
        'tanggalKirim': tanggalKirim,
        'items': items.map((i) => i.toJson()).toList(),
      };

  // ── Convert ke OrderSummary (untuk PaymentSuccessScreen) ──
  // Panggil ini setelah pembayaran sukses:
  //   final summary = order.toOrderSummary(shippingFee: 25000, discount: 0);
  OrderSummary toOrderSummary({
    required int shippingFee,
    int discount = 0,
    String promoCode = '-',
    String shippingType = '-',
  }) {
    return OrderSummary(
      items: items,
      orderDate: DateTime.tryParse(tanggalPesan) ?? DateTime.now(),
      promoCode: promoCode,
      shippingType: shippingType,
      subtotal: totalHarga.toDouble(),
      shippingFee: shippingFee.toDouble(),
      discount: discount.toDouble(),
      total: (totalHarga + shippingFee - discount).toDouble(),
    );
  }
}

// ─────────────────────────────────────────────
// OrderSummary  (untuk PaymentSuccessScreen & StrukPembayaranScreen)
// ─────────────────────────────────────────────
class OrderSummary {
  final List<OrderItem> items;
  final DateTime orderDate;
  final String promoCode;
  final String shippingType;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;

  const OrderSummary({
    required this.items,
    required this.orderDate,
    required this.promoCode,
    required this.shippingType,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
  });

  /// Data dummy untuk preview/testing
  static OrderSummary get sample => OrderSummary(
        items: const [
          OrderItem(
            productId: 1,
            name: 'Arm Chair',
            category: 'Chair',
            imageUrl: '',
            jumlah: 1,
            harga: 180000,
          ),
          OrderItem(
            productId: 2,
            name: 'Arm Chair',
            category: 'Chair',
            imageUrl: '',
            jumlah: 1,
            harga: 180000,
          ),
        ],
        orderDate: DateTime(2026, 9, 8, 13, 0),
        promoCode: 'ajnsjbfibejandj9',
        shippingType: 'JNE expres',
        subtotal: 500000,
        shippingFee: 500000,
        discount: 500000,
        total: 500000,
      );
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────

/// Format angka ke Rupiah: 180000 → "Rp180.000"
String fmtRp(double v) {
  final s = v.toInt().toString();
  final b = StringBuffer('Rp');
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

/// Overload untuk int (dari Order.totalHarga)
String fmtRpInt(int v) => fmtRp(v.toDouble());

/// Format DateTime ke string struk: "Sep, 8, 2026 | 13.00"
String fmtDate(DateTime d) {
  const months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '${months[d.month]}, ${d.day}, ${d.year} | $h.$m';
}

/// Parse tanggal string dari API (ISO 8601 atau fallback)
String fmtDateStr(String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  final d = DateTime.tryParse(raw);
  return d != null ? fmtDate(d) : raw;
}