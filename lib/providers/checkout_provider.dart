// checkout/checkout_provider.dart
// State management untuk seluruh flow checkout menggunakan Provider + ChangeNotifier

import 'package:flutter/material.dart';
import '../models/checkout_models.dart';
import '../services/order_service.dart';

class CheckoutProvider extends ChangeNotifier {
  // ── Address state ──────────────────────────────────────────────
  final List<ShippingAddress> _addresses = List.from(defaultAddresses);
  ShippingAddress _selectedAddress;

  List<ShippingAddress> get addresses => List.unmodifiable(_addresses);
  ShippingAddress get selectedAddress => _selectedAddress;

  // ── Shipping state ─────────────────────────────────────────────
  ShippingMethod _selectedShipping = shippingMethods.first;

  ShippingMethod get selectedShipping => _selectedShipping;

  // ── Order items state ──────────────────────────────────────────
  List<CheckoutItem> _items = [];

  List<CheckoutItem> get items => List.unmodifiable(_items);

  void loadFromCart(List<dynamic> cartItems) {
    _items = cartItems
        .map(
          (c) => CheckoutItem(
            id: c.id,
            name: c.name,
            category: c.category,
            price: c.pricePerUnit,
            imageUrl: c.imageUrl,
            quantity: c.quantity,
          ),
        )
        .toList();
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  // ── Totals ─────────────────────────────────────────────────────
  double _discount = 0;
  double _shippingDiscount = 0;
  final double _serviceFee = 2500;
  String? _appliedCoupon;
  
  double get discount => _discount;
  double get shippingDiscount => _shippingDiscount;
  double get serviceFee => _serviceFee;
  String? get appliedCoupon => _appliedCoupon;

  void applyCoupon(String code) {
    _appliedCoupon = code;
    if (code == 'FURNITURE10') {
      _discount = subtotal * 0.10;
      _shippingDiscount = 0;
    } else if (code == 'FREESHIP') {
      _discount = 0;
      _shippingDiscount = shippingCost;
    } else {
      _discount = 0;
      _shippingDiscount = 0;
    }
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discount = 0;
    _shippingDiscount = 0;
    notifyListeners();
  }

  double get subtotal => _items.fold(0, (sum, i) => sum + i.total);
  double get shippingCost => _selectedShipping.cost;
  double get grandTotal => subtotal + shippingCost - shippingDiscount + serviceFee - discount;

  // ─────────────────────────────────────────────────────────────
  CheckoutProvider() : _selectedAddress = defaultAddresses.first;

  // ── Address actions ────────────────────────────────────────────
  void selectAddress(ShippingAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addAddress(ShippingAddress address) {
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_selectedAddress.id == id && _addresses.isNotEmpty) {
      _selectedAddress = _addresses.first;
    }
    notifyListeners();
  }

  // ── Shipping actions ───────────────────────────────────────────
  void selectShipping(ShippingMethod method) {
    _selectedShipping = method;
    notifyListeners();
  }

  // ── Order item actions ─────────────────────────────────────────
  void updateQuantity(String itemId, int qty) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return;
    if (qty <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity = qty;
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;

  // ── Submit Order to API ─────────────────────────────────────────
  Future<bool> submitOrder() async {
    try {
      final response = await OrderService.checkout(
        address:
            _selectedAddress.city, // Menggunakan kota alamat sebagai contoh
        paymentMethod:
            'transfer', // Sementara hardcode atau bisa ditambahkan state payment
      );

      if (response['message'] == 'checkout berhasil' ||
          response['order_id'] != null) {
        _items.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }
}
