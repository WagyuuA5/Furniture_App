import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_furniture/providers/cart_provider.dart';
import 'package:app_furniture/features/cart/domain/usecases/cart_usecases.dart';
import 'package:app_furniture/features/cart/domain/entities/cart.dart';

class MockGetCart extends Mock implements GetCart {}
class MockAddToCart extends Mock implements AddToCart {}
class MockUpdateCart extends Mock implements UpdateCart {}
class MockRemoveFromCart extends Mock implements RemoveFromCart {}

void main() {
  late CartProvider cartProvider;
  late MockGetCart mockGetCart;
  late MockAddToCart mockAddToCart;
  late MockUpdateCart mockUpdateCart;
  late MockRemoveFromCart mockRemoveFromCart;

  setUp(() {
    mockGetCart = MockGetCart();
    mockAddToCart = MockAddToCart();
    mockUpdateCart = MockUpdateCart();
    mockRemoveFromCart = MockRemoveFromCart();

    cartProvider = CartProvider(
      getCartUseCase: mockGetCart,
      addToCartUseCase: mockAddToCart,
      updateCartUseCase: mockUpdateCart,
      removeFromCartUseCase: mockRemoveFromCart,
    );
  });

  group('CartProvider Tests', () {
    test('initial state is correct', () {
      expect(cartProvider.isLoading, isFalse);
      expect(cartProvider.cart, isNull);
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.totalCount, equals(0));
      expect(cartProvider.isEmpty, isTrue);
      expect(cartProvider.getTotalPrice(), equals(0.0));
    });

    test('loadCart success updates state correctly', () async {
      final mockCart = CartEntity(userId: 1, totalItem: 0, totalHarga: 0,
        items: [
          CartItemEntity(cartItemId: 1, productId: 101, name: 'Sofa', category: 'Living Room', imageUrl: 'sofa.jpg', pricePerUnit: 1000, quantity: 2),
        ],
      );
      when(() => mockGetCart()).thenAnswer((_) async => mockCart);

      await cartProvider.loadCart();

      expect(cartProvider.cart, equals(mockCart));
      expect(cartProvider.isLoading, isFalse);
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.totalCount, equals(2));
      expect(cartProvider.getTotalPrice(), equals(2000.0));
    });

    test('addItem triggers use case and reloads cart', () async {
      final mockCart = CartEntity(userId: 1, totalItem: 0, totalHarga: 0, items: []);
      when(() => mockAddToCart(101, 1)).thenAnswer((_) async {});
      when(() => mockGetCart()).thenAnswer((_) async => mockCart);

      await cartProvider.addItem(101, 1);

      verify(() => mockAddToCart(101, 1)).called(1);
      verify(() => mockGetCart()).called(1);
    });

    test('updateQuantity ignores if new quantity < 1', () async {
      final mockCart = CartEntity(userId: 1, totalItem: 0, totalHarga: 0,
        items: [
          CartItemEntity(cartItemId: 1, productId: 101, name: 'Sofa', category: 'Living Room', imageUrl: 'sofa.jpg', pricePerUnit: 1000, quantity: 1),
        ],
      );
      when(() => mockGetCart()).thenAnswer((_) async => mockCart);
      await cartProvider.loadCart();

      // delta is -1, so newQty would be 0
      await cartProvider.updateQuantity(1, -1);
      
      // update should not be called
      verifyNever(() => mockUpdateCart(any(), any()));
    });
  });
}
