// lib/utils/constants.dart
// Semua konstanta warna, string, dan style terpusat di sini

import 'package:flutter/material.dart';

// ── Current user (simulasi — ganti dengan Auth UID nyata) ─────────────────────
const String kCurrentUserId   = 'me';
const String kCurrentUserName = 'Mamad';
const String kAppLocation     = 'Indonesia, Malang';

// ── Warna ─────────────────────────────────────────────────────────────────────
class ChatColors {
  // Bubble chat
  static const bubbleMe    = Color(0xFF2C6E49);   // hijau teal — pesan saya
  static const bubbleOther = Color(0xFFF2F2F2);   // abu muda   — pesan lawan

  // Text di bubble
  static const textMe    = Colors.white;
  static const textOther = Color(0xFF1A1A1A);

  // UI umum
  static const bg         = Color(0xFFFAFAFA);
  static const surface    = Color(0xFFFFFFFF);
  static const primary    = Color(0xFF2C6E49);
  static const textPri    = Color(0xFF1A1A1A);
  static const textSec    = Color(0xFF8A8A8A);
  static const divider    = Color(0xFFEEECE8);
  static const inputBg    = Color(0xFFF2F2F2);
  static const online     = Color(0xFF4CAF50);
  static const offline    = Color(0xFF9E9E9E);
  static const badge      = Color(0xFFE53935);

  // Avatar palette (siklus berdasarkan index)
  static const avatarColors = [
    Color(0xFF2C6E49),
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFFE65100),
    Color(0xFF00838F),
    Color(0xFF558B2F),
  ];

  static Color avatarColor(int index) =>
      avatarColors[index % avatarColors.length];
}

// ── Shorthand alias agar file lain bisa tetap pakai AppColors.primary ─────────
class AppColors {
  static const primary      = ChatColors.primary;
  static const primaryDark  = Color(0xFF1E4D33);
  static const background   = ChatColors.bg;
  static const surface      = ChatColors.surface;
  static const textPrimary  = ChatColors.textPri;
  static const textSecondary = ChatColors.textSec;
  static const divider      = ChatColors.divider;
  static const error        = Color(0xFFE53935);
  static const blue         = Color(0xFF1E88E5);
}

// ── Radius ─────────────────────────────────────────────────────────────────────
class ChatRadius {
  static const bubbleMe    = BorderRadius.only(
    topLeft:     Radius.circular(20),
    topRight:    Radius.circular(20),
    bottomLeft:  Radius.circular(20),
    bottomRight: Radius.circular(4),
  );
  static const bubbleOther = BorderRadius.only(
    topLeft:     Radius.circular(4),
    topRight:    Radius.circular(20),
    bottomLeft:  Radius.circular(20),
    bottomRight: Radius.circular(20),
  );
}

// ── App string constants ───────────────────────────────────────────────────────
class AppStrings {
  static const appName        = 'ShopEase';
  static const processPayment = 'Proses Pembayaran';
  static const paymentMethod  = 'Metode Pembayaran';
  static const couponDiscount = 'Coupon';
  static const addCard        = 'Add Card';
}

// ── Dummy avatar warna per nama ────────────────────────────────────────────────
Color avatarColorFor(String name) {
  int hash = 0;
  for (final c in name.runes) {
    hash = (hash * 31 + c) & 0x7fffffff;
  }
  return ChatColors.avatarColors[hash % ChatColors.avatarColors.length];
}

// ─────────────────────────────────────────────────────────────────────────────
// CART MODELS  (dipakai oleh cart_screen, payment screens, dll.)
// ─────────────────────────────────────────────────────────────────────────────
class CartItem {
  final int    cartItemId;
  final int    productId;
  final String name;
  final String image;
  final int    harga;
  int          jumlah;
  final int    subtotal;

  // ── alias agar kode lama yang pakai field berbeda tetap kompilasi ──
  String get id       => cartItemId.toString();
  String get category => '';
  String get imageUrl => image;
  double get pricePerUnit => harga.toDouble();
  int    get quantity => jumlah;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.harga,
    required this.jumlah,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        cartItemId: json['cartItemId'] as int,
        productId:  json['productId']  as int,
        name:       json['name']       as String,
        image:      json['image']      as String,
        harga:      json['harga']      as int,
        jumlah:     json['jumlah']     as int,
        subtotal:   json['subtotal']   as int,
      );

  Map<String, dynamic> toJson() => {
        'cartItemId': cartItemId,
        'productId':  productId,
        'name':       name,
        'image':      image,
        'harga':      harga,
        'jumlah':     jumlah,
        'subtotal':   subtotal,
      };
}

class CartData {
  final int            userId;
  final int            totalItem;
  final int            totalHarga;
  final List<CartItem> items;

  CartData({
    required this.userId,
    required this.totalItem,
    required this.totalHarga,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        userId:      json['userId']      as int,
        totalItem:   json['totalItem']   as int,
        totalHarga:  json['totalHarga']  as int,
        items:       (json['items'] as List)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// CART PROVIDER  (ChangeNotifier — dipakai oleh payment_method_screen)
// ─────────────────────────────────────────────────────────────────────────────
// import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      cartItemId: 1,
      productId:  101,
      name:       'Modern Accent Chair',
      image:      '',
      harga:      600000,
      jumlah:     1,
      subtotal:   600000,
    ),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  double getTotalPrice() =>
      _items.fold(0, (sum, i) => sum + i.harga * i.jumlah);

  void updateQuantity(String id, int delta) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    final newQty = _items[idx].jumlah + delta;
    if (newQty <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx].jumlah = newQty;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORMAT HELPER
// ─────────────────────────────────────────────────────────────────────────────
String formatRupiah(double amount) {
  final str = amount.toStringAsFixed(0);
  final buf = StringBuffer('Rp');
  final len = str.length;
  for (int i = 0; i < len; i++) {
    if (i > 0 && (len - i) % 3 == 0) buf.write('.');
    buf.write(str[i]);
  }
  return buf.toString();
}