import 'package:flutter_test/flutter_test.dart';
import 'package:app_furniture/providers/checkout_provider.dart';
import 'package:app_furniture/models/checkout_models.dart';

void main() {
  late CheckoutProvider checkoutProvider;

  setUp(() {
    checkoutProvider = CheckoutProvider();
  });

  group('CheckoutProvider Tests', () {
    test('initial state has default shipping methods and addresses', () {
      expect(checkoutProvider.addresses, isNotEmpty);
      expect(checkoutProvider.selectedAddress, equals(checkoutProvider.addresses.first));
      expect(checkoutProvider.selectedShipping, isNotNull);
      expect(checkoutProvider.items, isEmpty);
      expect(checkoutProvider.discount, equals(0));
    });

    test('selectAddress updates selected address', () {
      final newAddress = ShippingAddress(
        id: '2',
        label: 'Kantor',
        street: 'Jl. Merdeka No. 2', city: 'Jakarta', state: 'DKI', zipCode: '10000',
        
        
      );
      checkoutProvider.addAddress(newAddress);
      
      checkoutProvider.selectAddress(newAddress);

      expect(checkoutProvider.selectedAddress, equals(newAddress));
    });

    test('loadFromCart maps items correctly', () {
      final mockCartItems = [
        (id: '1', name: 'Chair', category: 'Seating', pricePerUnit: 50000.0, imageUrl: '', quantity: 2),
      ];

      checkoutProvider.loadFromCart(mockCartItems);

      expect(checkoutProvider.items.length, equals(1));
      expect(checkoutProvider.items.first.name, equals('Chair'));
      expect(checkoutProvider.subtotal, equals(100000.0)); // 50000 * 2
    });

    test('applyCoupon calculates discounts correctly', () {
      // Mock some items to have a subtotal
      checkoutProvider.loadFromCart([
        (id: '1', name: 'Table', category: 'Desk', pricePerUnit: 100000.0, imageUrl: '', quantity: 1),
      ]); // subtotal = 100k

      checkoutProvider.applyCoupon('FURNITURE10');
      
      // FURNITURE10 gives 10% discount
      expect(checkoutProvider.discount, equals(10000.0));
      expect(checkoutProvider.appliedCoupon, equals('FURNITURE10'));
      expect(checkoutProvider.shippingDiscount, equals(0.0));
    });
    
    test('applyCoupon FREESHIP gives shipping discount', () {
      checkoutProvider.applyCoupon('FREESHIP');
      
      expect(checkoutProvider.shippingDiscount, equals(checkoutProvider.shippingCost));
      expect(checkoutProvider.discount, equals(0.0));
    });
  });
}
