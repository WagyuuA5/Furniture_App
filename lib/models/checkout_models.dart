// checkout/checkout_models.dart
// Data models untuk seluruh flow checkout

import 'package:flutter/material.dart';

// ─── Shipping Address ──────────────────────────────────────────────────────────
class ShippingAddress {
  final String id;
  String label;   // e.g. "Home", "Office"
  String street;
  String city;
  String state;
  String zipCode;

  ShippingAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  String get fullAddress => '$street, $city, $state $zipCode';
}

// ─── Shipping Method ───────────────────────────────────────────────────────────
class ShippingMethod {
  final String id;
  final String name;
  final String estimatedArrival;
  final double cost;
  final IconData icon;

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.estimatedArrival,
    required this.cost,
    required this.icon,
  });
}

// ─── Order Item ────────────────────────────────────────────────────────────────
class CheckoutItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  int quantity;

  CheckoutItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

// ─── Dummy Data ────────────────────────────────────────────────────────────────
List<ShippingAddress> defaultAddresses = [
  ShippingAddress(
    id: '1',
    label: 'Home',
    street: '1901 Thornridge Cir. Shiloh',
    city: 'Hawaii',
    state: 'HI',
    zipCode: '81063',
  ),
  ShippingAddress(
    id: '2',
    label: 'Office',
    street: '4517 Washington Ave. Manchester',
    city: 'Kentucky',
    state: 'KY',
    zipCode: '39495',
  ),
  ShippingAddress(
    id: '3',
    label: "Parent's House",
    street: '8502 Preston Rd. Inglewood',
    city: 'Maine',
    state: 'ME',
    zipCode: '98380',
  ),
  ShippingAddress(
    id: '4',
    label: "Friend's House",
    street: '2464 Royal Ln. Mesa',
    city: 'New Jersey',
    state: 'NJ',
    zipCode: '45463',
  ),
];

const List<ShippingMethod> shippingMethods = [
  ShippingMethod(
    id: 'economy',
    name: 'Economy',
    estimatedArrival: '25 Sep 2023',
    cost: 25,
    icon: Icons.inventory_2_outlined,
  ),
  ShippingMethod(
    id: 'regular',
    name: 'Regular',
    estimatedArrival: '24 Sep 2023',
    cost: 35,
    icon: Icons.local_shipping_outlined,
  ),
  ShippingMethod(
    id: 'cargo',
    name: 'Cargo',
    estimatedArrival: '22 Sep 2023',
    cost: 45,
    icon: Icons.airport_shuttle_outlined,
  ),
  ShippingMethod(
    id: 'express',
    name: 'Express',
    estimatedArrival: '20 Sep',
    cost: 55,
    icon: Icons.electric_rickshaw_outlined,
  ),
];

List<CheckoutItem> dummyOrderItems = [
  CheckoutItem(
    id: '1',
    name: 'Arm Chair',
    category: 'Chair',
    price: 180,
    imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300',
    quantity: 1,
  ),
  CheckoutItem(
    id: '2',
    name: 'Sofa Chair',
    category: 'Chair',
    price: 120,
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300',
    quantity: 1,
  ),
  CheckoutItem(
    id: '3',
    name: 'Wood Chair',
    category: 'Chair',
    price: 95,
    imageUrl: 'https://images.unsplash.com/photo-1561677843-39c91a321b35?w=300',
    quantity: 1,
  ),
];