// checkout/checkout_screen.dart
// Screen 1: Checkout Utama — pixel-perfect sesuai desain Gambar 1
// UPDATE dari versi lama: integrasi CheckoutProvider, address section baru,
// shipping section baru, order list dengan CHANGE button, payment summary dialog

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkout_provider.dart';
import '../utils/checkout_theme.dart';
import 'shipping_address_screen.dart';
import 'shipping_method_screen.dart';
import 'payment_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CheckoutBody();
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────
class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CheckoutProvider>();

    return Scaffold(
      backgroundColor: CC.bg,
      appBar: checkoutAppBar(context, 'Checkout'),
      body: prov.isEmpty
          ? const Center(
              child: Text(
                'Keranjang kosong',
                style: TextStyle(color: CC.textSec),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                // ── Shipping Address Section ───────────────────
                _ShippingAddressSection(prov: prov),

                _divider(),

                // ── Shipping Type Section ──────────────────────
                _ShippingTypeSection(prov: prov),

                _divider(),

                // ── Order List Section ─────────────────────────
                _OrderListSection(prov: prov),

                const SizedBox(height: 100),
              ],
            ),
      bottomNavigationBar: prov.isEmpty
          ? null
          : CheckoutBigButton(
              label: 'Lanjutkan ke Pembayaran',
              onTap: () => _onContinue(context, prov),
            ),
    );
  }

  void _onContinue(BuildContext context, CheckoutProvider prov) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          shippingMethod: prov.selectedShipping.name,
        ),
      ),
    );
  }

  Widget _divider() => const Divider(color: CC.divider, height: 1, thickness: 1);
}

// ── Shipping Address Section ──────────────────────────────────────────────────
class _ShippingAddressSection extends StatelessWidget {
  final CheckoutProvider prov;
  const _ShippingAddressSection({required this.prov});

  void _openAddressScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShippingAddressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addr = prov.selectedAddress;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Alamat Pengiriman'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location icon
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_outlined,
                    size: 20, color: CC.textPri),
              ),
              const SizedBox(width: 10),

              // Address info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addr.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CC.textPri,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      addr.fullAddress,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CC.textSec,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),
              ChangeButton(onTap: () => _openAddressScreen(context)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shipping Type Section ─────────────────────────────────────────────────────
class _ShippingTypeSection extends StatelessWidget {
  final CheckoutProvider prov;
  const _ShippingTypeSection({required this.prov});

  void _openShippingScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShippingMethodScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final method = prov.selectedShipping;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Pilih Jenis Pengiriman'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping icon
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(method.icon, size: 20, color: CC.textPri),
              ),
              const SizedBox(width: 10),

              // Method info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CC.textPri,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Estimasi Tiba  ${method.estimatedArrival}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CC.textSec,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),
              ChangeButton(onTap: () => _openShippingScreen(context)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Order List Section ────────────────────────────────────────────────────────
class _OrderListSection extends StatelessWidget {
  final CheckoutProvider prov;
  const _OrderListSection({required this.prov});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Daftar Pesanan'),
          const SizedBox(height: 14),
          ...prov.items.map(
            (item) => _OrderItemCard(item: item, prov: prov),
          ),
        ],
      ),
    );
  }
}

// ── Order Item Card ───────────────────────────────────────────────────────────
class _OrderItemCard extends StatelessWidget {
  final dynamic item; // CheckoutItem
  final CheckoutProvider prov;

  const _OrderItemCard({required this.item, required this.prov});

  void _openItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: prov,
        child: _OrderItemDialogInline(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CC.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CC.divider),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 72,
              height: 72,
              color: CC.bg,
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.chair_outlined,
                          size: 32,
                          color: CC.textSec),
                    )
                  : const Icon(Icons.chair_outlined,
                      size: 32, color: CC.textSec),
            ),
          ),
          const SizedBox(width: 14),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CC.textPri,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.category,
                  style: const TextStyle(fontSize: 12, color: CC.textSec),
                ),
                const SizedBox(height: 4),
                Text(
                  formatUSD(item.price),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CC.textSec,
                  ),
                ),
                if (item.quantity > 1)
                  Text(
                    'Qty: ${item.quantity}  •  Total: ${formatUSD(item.total)}',
                    style: const TextStyle(
                        fontSize: 11, color: CC.teal, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),

          // CHANGE button
          ChangeButton(
            label: 'UBAH',
            onTap: () => _openItemDialog(context),
          ),
        ],
      ),
    );
  }
}

// ── Inline Order Item Dialog (replaces missing OrderItemDialog) ────────────────
class _OrderItemDialogInline extends StatefulWidget {
  final dynamic item;
  const _OrderItemDialogInline({required this.item});

  @override
  State<_OrderItemDialogInline> createState() => _OrderItemDialogInlineState();
}

class _OrderItemDialogInlineState extends State<_OrderItemDialogInline> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CC.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.item.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: CC.textPri),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => setState(() { if (_qty > 1) _qty--; }),
            icon: const Icon(Icons.remove_circle_outline),
            color: CC.textSec,
          ),
          Text(
            '$_qty',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CC.textPri),
          ),
          IconButton(
            onPressed: () => setState(() => _qty++),
            icon: const Icon(Icons.add_circle_outline),
            color: CC.teal,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<CheckoutProvider>().removeItem(widget.item.id);
            Navigator.pop(context);
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<CheckoutProvider>().updateQuantity(widget.item.id, _qty);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CC.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}