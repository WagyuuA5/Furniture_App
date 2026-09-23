import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_furniture/widgets/product_card.dart';
import 'package:app_furniture/features/catalog/domain/entities/product.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('ProductCard displays product details correctly', (WidgetTester tester) async {
    final mockProduct = Product(
      id: 1,
      name: 'Luxury Sofa',
      category: 'Living Room',
      description: 'A very comfortable sofa.',
      price: 1500000,
      stock: 10,
      imageUrl: 'https://example.com/sofa.jpg',
      rating: 4.8,
      reviewCount: 120,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            product: mockProduct,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify product name
    expect(find.text('Luxury Sofa'), findsOneWidget);
    
    // Verify product category
    
    
    // Verify price string format (Rp1.500.000 or similar based on formatting)
    // We'll just look for the substring since the actual format might vary by locale setup
    expect(find.textContaining('1.500.000'), findsOneWidget);
  });
}
