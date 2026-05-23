// checkout/checkout_provider.dart
// State management untuk seluruh flow checkout menggunakan Provider + ChangeNotifier

import 'package:flutter/material.dart';
import '../models/checkout_models.dart';

class CheckoutProvider extends ChangeNotifier {
  // ── Address state ──────────────────────────────────────────────
  List<ShippingAddress> _addresses = List.from(defaultAddresses);
  ShippingAddress _selectedAddress;

  List<ShippingAddress> get addresses => List.unmodifiable(_addresses);
  ShippingAddress get selectedAddress => _selectedAddress;

  // ── Shipping state ─────────────────────────────────────────────
  ShippingMethod _selectedShipping = shippingMethods.first;

  ShippingMethod get selectedShipping => _selectedShipping;

  // ── Order items state ──────────────────────────────────────────
  List<CheckoutItem> _items = List.from(dummyOrderItems);

  List<CheckoutItem> get items => List.unmodifiable(_items);

  // ── Totals ─────────────────────────────────────────────────────
  double get subtotal => _items.fold(0, (sum, i) => sum + i.total);
  double get shippingCost => _selectedShipping.cost;
  double get grandTotal => subtotal + shippingCost;

  // ─────────────────────────────────────────────────────────────
  CheckoutProvider()
      : _selectedAddress = defaultAddresses.first;

  // ── Address actions ────────────────────────────────────────────
  void selectAddress(ShippingAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addAddress(ShippingAddress address) {
    _addresses.add(address);
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
}