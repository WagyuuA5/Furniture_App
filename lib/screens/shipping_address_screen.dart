// checkout/shipping_address_screen.dart
// Screen 2: Pilih Alamat Pengiriman — pixel-perfect sesuai desain Gambar 2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/checkout_models.dart';
import '../providers/checkout_provider.dart';
import '../utils/checkout_theme.dart';
import '../widgets/add_address_dialog.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  late ShippingAddress _tempSelected;

  @override
  void initState() {
    super.initState();
    // Copy selected address dari provider sebagai state sementara
    _tempSelected = context.read<CheckoutProvider>().selectedAddress;
  }

  void _openAddAddress() async {
    await showDialog(
      context: context,
      builder: (_) => const AddAddressDialog(),
    );
    // Setelah dialog tutup, refresh list
    setState(() {});
  }

  void _apply() {
    context.read<CheckoutProvider>().selectAddress(_tempSelected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckoutProvider>();
    final addresses = provider.addresses;

    return Scaffold(
      backgroundColor: CC.surface,
      appBar: checkoutAppBar(context, 'Shipping Address'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Address list ───────────────────────────────────────
          ...addresses.map((addr) => _AddressRow(
                address: addr,
                isSelected: _tempSelected.id == addr.id,
                onTap: () => setState(() => _tempSelected = addr),
              )),

          const SizedBox(height: 12),

          // ── Add New Address button ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: GestureDetector(
              onTap: _openAddAddress,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: CC.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CC.border,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: CC.textPri),
                    SizedBox(width: 8),
                    Text(
                      'Add New Shipping Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CC.textPri,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 80), // ruang untuk tombol apply
        ],
      ),
      bottomNavigationBar: CheckoutBigButton(
        label: 'Apply',
        onTap: _apply,
      ),
    );
  }
}

// ── Single Address Row ────────────────────────────────────────────────────────
class _AddressRow extends StatelessWidget {
  final ShippingAddress address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressRow({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CC.divider),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location icon
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.location_on_outlined,
                  size: 20, color: CC.textPri),
            ),
            const SizedBox(width: 12),

            // Label + address text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CC.textPri,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CC.textSec,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Radio indicator
            _RadioCircle(selected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ── Custom Radio Circle ────────────────────────────────────────────────────────
class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? CC.teal : CC.radioOff,
          width: selected ? 6 : 1.5,
        ),
        color: CC.surface,
      ),
    );
  }
}