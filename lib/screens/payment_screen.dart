import '../utils/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
 
import 'cart_screen.dart';
import 'qris_screen.dart';
import 'success_screen.dart';
import '../models/order.dart';
import 'coupon_screen.dart';
import 'add_card_screen.dart';
import '../providers/checkout_provider.dart';
import '../providers/product_provider.dart';
import '../models/checkout_models.dart';

// ── Warna ─────────────────────────────────────────────────────────────────────
class _C {
  static const bg       = Color(0xFFFAFAFA);
  static const surface  = AppColors.white;
  static const teal     = AppColors.accent;
  static const textPri  = AppColors.textPrimary;
  static const textSec  = AppColors.textSecondary;
  static const divider  = AppColors.divider;
}

// ── Metode Pembayaran ─────────────────────────────────────────────────────────
enum _PayMethod { qris, cod, transfer }

// ─────────────────────────────────────────────────────────────────────────────
class PaymentMethodScreen extends StatefulWidget {
  final String shippingMethod;
  const PaymentMethodScreen({super.key, required this.shippingMethod});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  _PayMethod _method  = _PayMethod.qris;
  double _discount    = 0;
  final double _ongkir        = 15000;
  final double _diskonOngkir  = 0;
  final double _biayaLayanan  = 2000;
  final TextEditingController _discCtrl = TextEditingController();

  @override
  void dispose() {
    _discCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCoupon(double subTotal) async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CouponScreen(onApply: (c) {}),
      ),
    );
    if (code != null && mounted) {
      _discCtrl.text = code;
      _applyDiskon(subTotal);
    }
  }

  void _applyDiskon(double subTotal) {
    final code = _discCtrl.text.trim().toUpperCase();
    setState(() {
      _discount = 0;
      if (code == 'DISKON10') _discount = subTotal * 0.10;
      else if (code == 'WELCOME200') _discount = subTotal * 0.50;
      else if (code == 'FREESHIP') _discount = _ongkir;
      else if (code == 'NEWUSER50') _discount = (subTotal * 0.50).clamp(0, 50000);
      else if (code == 'LUXURY25') _discount = subTotal * 0.25;
      else if (code == 'CASHBACK12') _discount = 12000;
      else if (code.isNotEmpty) _discount = 15000;
    });
  }

  OrderSummary _buildOrderSummary(CheckoutProvider checkout) {
    return OrderSummary(
      items: checkout.items.map((ci) => OrderItem(
        productId: int.tryParse(ci.id) ?? 0,
        name: ci.name,
        category: ci.category,
        imageUrl: ci.imageUrl,
        price: ci.price,
        quantity: ci.quantity,
      )).toList(),
      subtotal: checkout.subtotal,
      shippingFee: checkout.shippingCost - checkout.shippingDiscount + checkout.serviceFee,
      discount: checkout.discount,
      total: checkout.grandTotal,
    );
  }

  bool _isProcessing = false;

  void _onProses(BuildContext context, CheckoutProvider checkout) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Stock Revalidation
    final productProv = context.read<ProductProvider>();
    await productProv.loadProducts(); // Fetch latest stock
    
    List<String> outOfStock = [];
    for (var item in checkout.items) {
      final product = productProv.getProductById(int.tryParse(item.id) ?? 0);
      if (product == null || product.stock < item.quantity) {
        outOfStock.add(item.name);
      }
    }

    if (outOfStock.isNotEmpty) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maaf, stok tidak cukup untuk: '),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = false);

    final orderSummary = _buildOrderSummary(checkout);

    if (_method == _PayMethod.qris) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => QrisScreen(orderSummary: orderSummary)));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => SuccessScreen(orderSummary: orderSummary)));
    }
  }
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
        backgroundColor: _C.surface,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _C.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.divider),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: _C.textPri),
          ),
        ),
        title: const Text('Proses Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _C.textPri)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: _C.divider)),
      );

  // ── Info user ──────────────────────────────────────────────────────────────
  Widget _buildUserInfo(ShippingAddress address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 16, color: _C.textPri),
            const SizedBox(width: 6),
            Text(address.label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: _C.textPri)),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            address.fullAddress,
            style: const TextStyle(fontSize: 12, color: _C.textSec, height: 1.6),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.chevron_right, size: 18, color: _C.textSec),
          ],
        ),
      ],
    );
  }

  // ── Input Diskon ───────────────────────────────────────────────────────────
  Widget _buildDiskonField(double subTotal) {
    final hasDiskon = _discount > 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openCoupon(subTotal),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasDiskon ? _C.teal.withOpacity(0.5) : _C.divider,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.local_offer_outlined,
                size: 20, color: hasDiskon ? _C.teal : _C.textSec),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasDiskon
                    ? 'Kupon "${_discCtrl.text}" diterapkan ✓'
                    : 'Diskon / Kupon',
                style: TextStyle(
                  fontSize: 13,
                  color: hasDiskon ? _C.teal : _C.textSec,
                  fontWeight: hasDiskon ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (hasDiskon)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _discount = 0;
                    _discCtrl.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.close_rounded, size: 18, color: _C.textSec),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: _C.divider)),
                ),
                child: const Icon(Icons.chevron_right, size: 20, color: _C.textSec),
              ),
          ],
        ),
      ),
    );
  }

  // ── Ringkasan Pesanan ──────────────────────────────────────────────────────
  Widget _buildRingkasan(double subTotal, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Pesanan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.textPri)),
          const SizedBox(height: 12),

          // Subtotal Produk header
          const _RingkasanHeader('Subtotal Produk'),
          _RingkasanRow('Harga Asli',         formatRupiah(subTotal)),
          _RingkasanRow('Diskon Produk',
              _discount > 0 ? '- ${formatRupiah(_discount)}' : '-',
              valueColor: _discount > 0 ? _C.teal : _C.textSec),
          const SizedBox(height: 10),

          // Subtotal Ongkir header
          const _RingkasanHeader('Subtotal Ongkir'),
          _RingkasanRow('Ongkir',          formatRupiah(_ongkir)),
          _RingkasanRow('Diskon Ongkir',   _diskonOngkir > 0 ? '- ${formatRupiah(_diskonOngkir)}' : '-'),
          _RingkasanRow('Biaya Layanan Pelanggan', formatRupiah(_biayaLayanan)),
          const SizedBox(height: 12),

          // Dashed divider
          const _DashedLine(),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _C.textPri)),
              Text(formatRupiah(total),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: _C.teal)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Metode Pembayaran ──────────────────────────────────────────────────────
  Widget _buildPaymentMethods() {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        children: [
          _PaymentTile(
            label: 'Qris',
            logo: const _QrisLogo(),
            selected: _method == _PayMethod.qris,
            onTap: () => setState(() => _method = _PayMethod.qris),
          ),
          const Divider(color: _C.divider, height: 1),
          _PaymentTile(
            label: 'Bayar Di Tempat',
            logo: const _CodLogo(),
            selected: _method == _PayMethod.cod,
            onTap: () => setState(() => _method = _PayMethod.cod),
          ),
          const Divider(color: _C.divider, height: 1),
          // Transfer bank → arrow ke sub-pilihan
          _PaymentTile(
            label: 'Kartu Kredit / Debit',
            logo: const _BankLogos(),
            selected: _method == _PayMethod.transfer,
            onTap: () {
              setState(() => _method = _PayMethod.transfer);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCardScreen()),
              );
            },
            trailing: const Icon(Icons.chevron_right, color: _C.textSec),
          ),
        ],
      ),
    );
  }
}

// ── Order Row ─────────────────────────────────────────────────────────────────
class _OrderRow extends StatelessWidget {
  final CheckoutItem item;
  const _OrderRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 72, height: 72,
              color: const Color(0xFFF0EFED),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: _C.textPri)),
                const SizedBox(height: 4),
                Text(formatRupiah(item.price),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: _C.teal)),
              ],
            ),
          ),
          Text('x ', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}



// ── Ringkasan helpers ─────────────────────────────────────────────────────────
class _RingkasanHeader extends StatelessWidget {
  final String label;
  const _RingkasanHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: _C.textPri)),
      );
}

class _RingkasanRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _RingkasanRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: _C.textSec)),
            Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? _C.textPri)),
          ],
        ),
      );
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      const w = 6.0, g = 4.0;
      final n = (c.maxWidth / (w + g)).floor();
      return Row(
        children: List.generate(n, (_) => Row(children: [
          Container(width: w, height: 1, color: _C.divider),
          const SizedBox(width: g),
        ])),
      );
    });
  }
}

// ── Payment Tile ──────────────────────────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final String label;
  final Widget logo;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;
  const _PaymentTile({
    required this.label, required this.logo,
    required this.selected, required this.onTap, this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            logo,
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: _C.textPri)),
            ),
            trailing ?? _Radio(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  final bool selected;
  const _Radio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.accent : const Color(0xFFCCCCCC),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

// ── Logo widgets ──────────────────────────────────────────────────────────────
class _QrisLogo extends StatelessWidget {
  const _QrisLogo();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4ED),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('QRIS',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.accent)),
      );
}

class _CodLogo extends StatelessWidget {
  const _CodLogo();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('COD',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF856404))),
      );
}

class _BankLogos extends StatelessWidget {
  const _BankLogos();

  @override
  Widget build(BuildContext context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BankChip('VISA', Colors.blue),
          SizedBox(width: 4),
          _BankChip('mandiri', Color(0xFF003087)),
          SizedBox(width: 4),
          _BankChip('BCA', Color(0xFF003087)),
        ],
      );
}

class _BankChip extends StatelessWidget {
  final String text;
  final Color color;
  const _BankChip(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w800, color: color)),
      );
}
