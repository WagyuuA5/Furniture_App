// lib/screens/cart_screen.dart
//
// UPDATE:
//  - Bottom bar: tambah kode promo, sub total, delivery fee, discount, total
//  - Desain 1:1 dengan Figma (gambar kanan)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/checkout_provider.dart';

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────
class CartItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double pricePerUnit;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.pricePerUnit,
    this.quantity = 1,
  });

  double get totalPrice => pricePerUnit * quantity;

  factory CartItem.fromProduct(ProductModel product) => CartItem(
        id: product.id,
        name: product.name,
        category: product.categoryId,
        imageUrl: product.imageUrl,
        pricePerUnit: product.price,
      );
}

// ─────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalCount => _items.fold(0, (s, i) => s + i.quantity);
  bool get isEmpty => _items.isEmpty;

  double getTotalPrice() => _items.fold(0, (sum, i) => sum + i.totalPrice);

  void addItem(CartItem item) {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int delta) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final newQty = _items[idx].quantity + delta;
    if (newQty < 1) return;
    _items[idx].quantity = newQty;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────
String formatRupiah(double amount) {
  final parts = amount.toStringAsFixed(0).split('');
  final buffer = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
    buffer.write(parts[i]);
  }
  return 'Rp${buffer.toString()}';
}

// ─────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────
class _LT {
  static const Color bg          = Color(0xFFFAF9F7);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color accent      = Color(0xFF2C6E49);
  static const Color accentLight = Color(0xFFE8F4ED);
  static const Color danger      = Color(0xFFD62839);
  static const Color dangerLight = Color(0xFFFFF0F1);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color divider     = Color(0xFFEEECE8);
  static const Color qtyBg       = Color(0xFF1A1A1A);
  static const Color inputBg     = Color(0xFFF0EFED);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class CartScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const CartScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) => _CartView(onBack: onBack);
}

// ─────────────────────────────────────────────
// CART VIEW  (StatefulWidget agar bisa kelola
// state kode promo & expand/collapse summary)
// ─────────────────────────────────────────────
class _CartView extends StatefulWidget {
  final VoidCallback? onBack;
  const _CartView({this.onBack});

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  final TextEditingController _promoCtrl = TextEditingController();
  double _discount      = 0;
  double _deliveryFee   = 50000; // dummy
  bool   _promoApplied  = false;
  bool   _summaryExpanded = true;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    setState(() {
      if (code == 'DISKON10') {
        _discount     = context.read<CartProvider>().getTotalPrice() * 0.10;
        _promoApplied = true;
      } else {
        _discount     = 0;
        _promoApplied = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kode promo tidak valid'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _LT.danger,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _LT.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, _) {
                  if (cart.isEmpty) return _buildEmptyState();
                  return _buildList(context, cart);
                },
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                if (cart.isEmpty) return const SizedBox.shrink();
                return _buildBottomPanel(context, cart);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: _LT.surface,
        border: Border(bottom: BorderSide(color: _LT.divider)),
      ),
      child: Row(
        children: [
          _CircleBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              if (widget.onBack != null) widget.onBack!();
              else Navigator.of(context).pop();
            },
          ),
          const Expanded(
            child: Text(
              'Keranjang Saya',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _LT.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, __) => Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _LT.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${cart.totalCount}',
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _LT.accent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── List ────────────────────────────────────
  Widget _buildList(BuildContext context, CartProvider cart) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const Divider(color: _LT.divider, height: 1),
      itemBuilder: (_, i) => _CartItemCard(item: cart.items[i]),
    );
  }

  // ── Empty ───────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: _LT.accentLight,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.shopping_cart_outlined, size: 48, color: _LT.accent),
          ),
          const SizedBox(height: 24),
          const Text('Keranjang kosong',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 20,
                  fontWeight: FontWeight.w600, color: _LT.textPrimary)),
          const SizedBox(height: 8),
          const Text('Belum ada produk yang ditambahkan',
              style: TextStyle(fontSize: 14, color: _LT.textSecondary)),
        ],
      ),
    );
  }

  // ── Bottom Panel (UPDATED) ───────────────────
  Widget _buildBottomPanel(BuildContext context, CartProvider cart) {
    final subTotal   = cart.getTotalPrice();
    final totalBayar = subTotal + _deliveryFee - _discount;

    return Container(
      decoration: BoxDecoration(
        color: _LT.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle + toggle ─────────────
          GestureDetector(
            onTap: () => setState(() => _summaryExpanded = !_summaryExpanded),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: _LT.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    _summaryExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: _LT.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable summary ───────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: _summaryExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                children: [
                  // Kode Promo
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: _LT.inputBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _promoCtrl,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _LT.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Kode Promo',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: _LT.textSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _applyPromo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _LT.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: const Text(
                            'Gunakan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_promoApplied) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 14, color: _LT.accent),
                        const SizedBox(width: 6),
                        Text(
                          'Kode promo berhasil diterapkan!',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _LT.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Breakdown harga ──────────
                  _PriceRow(label: 'Sub Total',    value: formatRupiah(subTotal)),
                  const SizedBox(height: 8),
                  _PriceRow(label: 'Delivery Fee', value: formatRupiah(_deliveryFee)),
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Discount',
                    value: _discount > 0 ? '- ${formatRupiah(_discount)}' : '-',
                    valueColor: _discount > 0 ? _LT.accent : _LT.textSecondary,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: DashedDivider(),
                  ),

                  // ── Total Pembayaran ─────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _LT.textPrimary,
                        ),
                      ),
                      Text(
                        formatRupiah(totalBayar),
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _LT.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),

          // ── Tombol Proses Pembayaran ─────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  final cartItems = context.read<CartProvider>().items;
                  context.read<CheckoutProvider>().loadFromCart(cartItems);
                  Navigator.of(context).pushNamed('/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _LT.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Proses Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRICE ROW WIDGET
// ─────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _PriceRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: _LT.textSecondary)),
        Text(value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? _LT.textPrimary,
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DASHED DIVIDER
// ─────────────────────────────────────────────
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 6.0;
        const gapW  = 4.0;
        final count = (constraints.maxWidth / (dashW + gapW)).floor();
        return Row(
          children: List.generate(count, (_) => Row(children: [
            Container(width: dashW, height: 1, color: _LT.divider),
            const SizedBox(width: gapW),
          ])),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// CART ITEM CARD
// ─────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  void _confirmRemove(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _confirmRemove(context);
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(left: 60),
        decoration: BoxDecoration(
          color: _LT.dangerLight,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: _LT.danger, size: 24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 80, height: 80,
                color: _LT.bg,
                child: item.imageUrl.isNotEmpty
                    ? Image.network(item.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.chair_outlined, size: 36, color: _LT.textSecondary))
                    : const Icon(Icons.chair_outlined, size: 36, color: _LT.textSecondary),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                        fontFamily: 'Georgia', fontSize: 15,
                        fontWeight: FontWeight.w700, color: _LT.textPrimary,
                      )),
                  const SizedBox(height: 2),
                  Text(item.category,
                      style: const TextStyle(fontSize: 12, color: _LT.textSecondary)),
                  const SizedBox(height: 4),
                  Text(formatRupiah(item.pricePerUnit),
                      style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: _LT.textSecondary,
                      )),
                ],
              ),
            ),
            // Qty
            _QtySelector(
              quantity: item.quantity,
              onDec: () => cart.updateQuantity(item.id, -1),
              onInc: () => cart.updateQuantity(item.id, 1),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// QUANTITY SELECTOR
// ─────────────────────────────────────────────
class _QtySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDec;
  final VoidCallback onInc;
  const _QtySelector({required this.quantity, required this.onDec, required this.onInc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyBtn(icon: Icons.remove, onTap: onDec, filled: false),
        SizedBox(
          width: 30,
          child: Text('$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: _LT.textPrimary,
              )),
        ),
        _QtyBtn(icon: Icons.add, onTap: onInc, filled: true),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QtyBtn({required this.icon, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: filled ? _LT.qtyBg : _LT.bg,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : Border.all(color: _LT.divider),
        ),
        child: Icon(icon, size: 14, color: filled ? Colors.white : _LT.textPrimary),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REMOVE CONFIRM SHEET
// ─────────────────────────────────────────────
class _RemoveSheet extends StatelessWidget {
  final CartItem item;
  const _RemoveSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: _LT.surface,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: _LT.divider, borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text('Remove from Cart?',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 20,
                  fontWeight: FontWeight.w700, color: _LT.textPrimary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _LT.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _LT.divider),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 56, height: 56, color: _LT.surface,
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(item.imageUrl, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.chair_outlined, size: 28, color: _LT.textSecondary))
                        : const Icon(Icons.chair_outlined, size: 28, color: _LT.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(fontFamily: 'Georgia', fontSize: 15,
                              fontWeight: FontWeight.w700, color: _LT.textPrimary)),
                      Text(item.category,
                          style: const TextStyle(fontSize: 12, color: _LT.textSecondary)),
                      Text(formatRupiah(item.pricePerUnit),
                          style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w700, color: _LT.accent)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _LT.textPrimary,
                      side: const BorderSide(color: _LT.divider, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartProvider>().removeItem(item.id);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _LT.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Yes, Remove',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE CIRCLE BUTTON
// ─────────────────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: _LT.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _LT.divider),
        ),
        child: Icon(icon, size: 16, color: _LT.textPrimary),
      ),
    );
  }
}