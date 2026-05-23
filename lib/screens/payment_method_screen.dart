// lib/screens/payment_method_screen.dart
//
// Halaman Metode Pembayaran
// - Field Diskon → GestureDetector → buka CouponScreen
// - Transfer tile → chips VISA/mandiri/BCA + chevron → BankSelectionScreen
// - Menggunakan CartProvider dari constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import 'coupon_screen.dart';
import 'add_card_screen.dart';

// ── Warna lokal ────────────────────────────────────────────────────────────────
class _C {
  static const bg      = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const teal    = Color(0xFF2C6E49);
  static const textPri = Color(0xFF1A1A1A);
  static const textSec = Color(0xFF8A8A8A);
  static const divider = Color(0xFFEEECE8);
}

enum _PayMethod { qris, cod, transfer }

// ──────────────────────────────────────────────────────────────────────────────
class PaymentMethodScreen extends StatefulWidget {
  final String shippingMethod;

  const PaymentMethodScreen({
    super.key,
    this.shippingMethod = 'Regular',
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  _PayMethod _method       = _PayMethod.qris;
  double     _discount     = 0;
  String     _appliedPromo = '-';

  final double _ongkir       = 15000;
  final double _diskonOngkir = 0;
  final double _biayaLayanan = 2000;

  // ── Navigasi ke CouponScreen ────────────────────────────────────────────────
  Future<void> _openCoupon(double subTotal) async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CouponScreen(
          onApply: (c) {},
        ),
      ),
    );
    if (code != null && mounted) {
      setState(() {
        _appliedPromo = code;
        switch (code.toUpperCase()) {
          case 'DISKON10':
            _discount = subTotal * 0.10;
            break;
          case 'WELCOME200':
            _discount = subTotal * 0.50;
            break;
          case 'FREESHIP':
            _discount = _ongkir;
            break;
          case 'NEWUSER50':
            _discount = (subTotal * 0.50).clamp(0, 50000);
            break;
          case 'LUXURY25':
            _discount = subTotal * 0.25;
            break;
          case 'PAYDAY25':
            _discount = subTotal * 0.25;
            break;
          case 'CASHBACK12':
            _discount = 12000;
            break;
          default:
            _discount = 15000;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('Kupon "$code" berhasil diterapkan!',
                style: GoogleFonts.poppins(fontSize: 13)),
          ]),
          backgroundColor: _C.teal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ── Proses pembayaran ────────────────────────────────────────────────────────
  void _onProses(BuildContext context, CartProvider cart, double total) {
    // Simulasi sukses — tampilkan bottom sheet sukses
    _showSuccessSheet(total);
  }

  void _showSuccessSheet(double total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _SuccessSheet(total: total),
    ).then((_) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart     = context.watch<CartProvider>();
    final subTotal = cart.getTotalPrice();
    final total    = subTotal + _ongkir - _diskonOngkir + _biayaLayanan - _discount;

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ── Info User & Alamat ──────────────────────────────────────────────
          _buildUserInfo(),
          const Divider(color: _C.divider, height: 24),

          // ── Item Pesanan ────────────────────────────────────────────────────
          ...cart.items.map((item) => _OrderRow(item: item)),
          const Divider(color: _C.divider, height: 24),

          // ── Field Diskon (tap → CouponScreen) ──────────────────────────────
          _buildDiskonField(subTotal),
          const SizedBox(height: 16),

          // ── Ringkasan Pesanan ───────────────────────────────────────────────
          _buildRingkasan(subTotal, total),
          const SizedBox(height: 24),

          // ── Metode Pembayaran ───────────────────────────────────────────────
          Text('Metode Pembayaran',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _C.textPri)),
          const SizedBox(height: 12),
          _buildPaymentMethods(context),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () => _onProses(context, cart, total),
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Proses Pembayaran',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
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
        title: Text('Proses Pembayaran',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _C.textPri)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _C.divider),
        ),
      );

  // ── Info user & alamat ──────────────────────────────────────────────────────
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.location_on_rounded,
              size: 16, color: _C.textPri),
          const SizedBox(width: 6),
          Text('mamad (08******97)',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textPri)),
        ]),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            'Jalan Danau Tambingan G6D-19, Kelurahan Sawojajar,\n'
            'kedungkandang, Kota Malang, Jawa Timur',
            style: GoogleFonts.poppins(
                fontSize: 12, color: _C.textSec, height: 1.6),
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

  // ── Field Diskon ─────────────────────────────────────────────────────────────
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
            Icon(
              Icons.local_offer_outlined,
              size: 20,
              color: hasDiskon ? _C.teal : _C.textSec,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasDiskon
                    ? 'Kupon "$_appliedPromo" diterapkan ✓'
                    : 'Diskon / Kupon',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: hasDiskon ? _C.teal : _C.textSec,
                  fontWeight:
                      hasDiskon ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (hasDiskon)
              GestureDetector(
                onTap: () => setState(() {
                  _discount     = 0;
                  _appliedPromo = '-';
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: _C.textSec),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: _C.divider)),
                ),
                child: const Icon(Icons.chevron_right,
                    size: 20, color: _C.textSec),
              ),
          ],
        ),
      ),
    );
  }

  // ── Ringkasan Pesanan ─────────────────────────────────────────────────────────
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
          Text('Ringkasan Pesanan',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textPri)),
          const SizedBox(height: 12),
          _RingkasanHeader('Subtotal Produk'),
          _RingkasanRow('Harga Asli', formatRupiah(subTotal)),
          _RingkasanRow(
            'Diskon Produk',
            _discount > 0 ? '- ${formatRupiah(_discount)}' : '-',
            valueColor: _discount > 0 ? _C.teal : _C.textSec,
          ),
          const SizedBox(height: 10),
          _RingkasanHeader('Subtotal Ongkir'),
          _RingkasanRow('Ongkir', formatRupiah(_ongkir)),
          _RingkasanRow(
            'Diskon Ongkir',
            _diskonOngkir > 0
                ? '- ${formatRupiah(_diskonOngkir)}'
                : '-',
          ),
          _RingkasanRow(
              'Biaya Layanan Pelanggan', formatRupiah(_biayaLayanan)),
          const SizedBox(height: 12),
          _DashedLine(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _C.textPri)),
              Text(formatRupiah(total),
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _C.teal)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Metode Pembayaran ─────────────────────────────────────────────────────────
  Widget _buildPaymentMethods(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        children: [
          // QRIS
          _PaymentTile(
            label: 'QRIS',
            logo: _QrisLogo(),
            selected: _method == _PayMethod.qris,
            onTap: () => setState(() => _method = _PayMethod.qris),
          ),
          Container(height: 1, color: _C.divider),

          // COD
          _PaymentTile(
            label: 'Bayar Di Tempat (COD)',
            logo: _CodLogo(),
            selected: _method == _PayMethod.cod,
            onTap: () => setState(() => _method = _PayMethod.cod),
          ),
          Container(height: 1, color: _C.divider),

          // Kartu / Transfer → AddCardScreen
          _PaymentTile(
            label: 'Kartu Kredit / Debit',
            logo: _BankLogosRow(),
            selected: _method == _PayMethod.transfer,
            onTap: () {
              setState(() => _method = _PayMethod.transfer);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddCardScreen()),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BankChip('VISA', Colors.blue.shade700),
                const SizedBox(width: 4),
                _BankChip('mandiri', const Color(0xFF003087)),
                const SizedBox(width: 4),
                _BankChip('BCA', const Color(0xFF003087)),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right,
                    color: _C.textSec, size: 18),
              ],
            ),
          ),

          // ── Debit Instan ─────────────────────────────────────────────────
          Container(height: 1, color: _C.divider),
          _buildDebitSection(),
        ],
      ),
    );
  }

  // ── Debit Instan section ──────────────────────────────────────────────────────
  Widget _buildDebitSection() {
    final methods = [
      _DebitEntry('CIMB Direct Debit', 'CIMB', const Color(0xFFDD0000)),
      _DebitEntry('BCA OneKlik',        'BCA',  const Color(0xFF005BAA)),
      _DebitEntry('BRI Direct Debit',   'BRI',  const Color(0xFF003580)),
      _DebitEntry('Tambah Debit Instan','  +',  _C.teal, badge: '+1', onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddCardScreen()),
        );
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text('Debit Instan',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _C.textPri)),
        ),
        ...methods.map((m) => _DebitRow(entry: m)),
        const SizedBox(height: 6),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DEBIT ENTRY MODEL + ROW
// ─────────────────────────────────────────────
class _DebitEntry {
  final String name;
  final String logoText;
  final Color  logoColor;
  final String? badge;
  final VoidCallback? onTap;

  const _DebitEntry(this.name, this.logoText, this.logoColor,
      {this.badge, this.onTap});
}

class _DebitRow extends StatelessWidget {
  final _DebitEntry entry;

  const _DebitRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEECE8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: entry.logoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: entry.logoColor.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Text(entry.logoText,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: entry.logoColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(entry.name,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A))),
                if (entry.badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(entry.badge!,
                        style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: entry.onTap ?? () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Menghubungkan ke ${entry.name}...',
                    style: GoogleFonts.poppins(fontSize: 13)),
                backgroundColor: const Color(0xFF2C6E49),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 1),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2C6E49).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF2C6E49).withOpacity(0.4)),
              ),
              child: const Text('Tambah',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C6E49))),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ORDER ROW
// ─────────────────────────────────────────────
class _OrderRow extends StatelessWidget {
  final CartItem item;

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
              width: 72,
              height: 72,
              color: const Color(0xFFF0EFED),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.chair_outlined,
                          size: 32,
                          color: Color(0xFF8A8A8A)))
                  : const Icon(Icons.chair_outlined,
                      size: 32, color: Color(0xFF8A8A8A)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A))),
                Text(item.category,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF8A8A8A))),
                const SizedBox(height: 4),
                Text(formatRupiah(item.pricePerUnit),
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8A8A8A))),
              ],
            ),
          ),
          _MiniQty(item: item),
        ],
      ),
    );
  }
}

class _MiniQty extends StatelessWidget {
  final CartItem item;

  const _MiniQty({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QBtn(
            icon: Icons.remove,
            onTap: () => cart.updateQuantity(item.id, -1)),
        SizedBox(
          width: 28,
          child: Text('${item.jumlah}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700)),
        ),
        _QBtn(
            icon: Icons.add,
            filled: true,
            onTap: () => cart.updateQuantity(item.id, 1)),
      ],
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QBtn(
      {required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: filled
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFF0EFED),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon,
            size: 13,
            color: filled ? Colors.white : const Color(0xFF1A1A1A)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RINGKASAN HELPERS
// ─────────────────────────────────────────────
class _RingkasanHeader extends StatelessWidget {
  final String label;

  const _RingkasanHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A))),
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
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF8A8A8A))),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        valueColor ?? const Color(0xFF1A1A1A))),
          ],
        ),
      );
}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      const w = 6.0, g = 4.0;
      final n = (c.maxWidth / (w + g)).floor();
      return Row(
        children: List.generate(
          n,
          (_) => Row(children: [
            Container(
                width: w,
                height: 1,
                color: const Color(0xFFEEECE8)),
            const SizedBox(width: g),
          ]),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// PAYMENT TILE
// ─────────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final String label;
  final Widget logo;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _PaymentTile({
    required this.label,
    required this.logo,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          logo,
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _C.textPri)),
          ),
          trailing ?? _Radio(selected: selected),
        ]),
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
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? const Color(0xFF2C6E49)
              : const Color(0xFFCCCCCC),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                    color: Color(0xFF2C6E49),
                    shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

// ─────────────────────────────────────────────
// LOGO WIDGETS
// ─────────────────────────────────────────────
class _QrisLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4ED),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('QRIS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C6E49))),
      );
}

class _CodLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('COD',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF856404))),
      );
}

class _BankLogosRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BankChip('VISA', Colors.blue.shade700),
          const SizedBox(width: 4),
          _BankChip('mandiri', const Color(0xFF003087)),
          const SizedBox(width: 4),
          _BankChip('BCA', const Color(0xFF003087)),
        ],
      );
}

class _BankChip extends StatelessWidget {
  final String text;
  final Color color;

  const _BankChip(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: color)),
      );
}

// ─────────────────────────────────────────────
// SUCCESS BOTTOM SHEET
// ─────────────────────────────────────────────
class _SuccessSheet extends StatelessWidget {
  final double total;

  const _SuccessSheet({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2C6E49).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF2C6E49), size: 48),
            ),
            const SizedBox(height: 20),
            Text('Pembayaran Berhasil!',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A))),
            const SizedBox(height: 8),
            Text('Pesanan kamu sedang diproses',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF8A8A8A))),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Dibayar',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF8A8A8A))),
                  Text(formatRupiah(total),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C6E49))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C6E49),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text('Kembali ke Beranda',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}