// checkout/shipping_method_screen.dart
// Screen 3: Pilih Metode Pengiriman — pixel-perfect sesuai desain Gambar 3

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/checkout_models.dart';
import '../providers/checkout_provider.dart';
import '../utils/checkout_theme.dart';

class ShippingMethodScreen extends StatefulWidget {
  const ShippingMethodScreen({super.key});

  @override
  State<ShippingMethodScreen> createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  late ShippingMethod _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = context.read<CheckoutProvider>().selectedShipping;
  }

  void _apply() {
    context.read<CheckoutProvider>().selectShipping(_tempSelected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CC.surface,
      appBar: checkoutAppBar(context, 'Choose Shipping'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        children: shippingMethods
            .map((method) => _ShippingRow(
                  method: method,
                  isSelected: _tempSelected.id == method.id,
                  onTap: () => setState(() => _tempSelected = method),
                ))
            .toList(),
      ),
      bottomNavigationBar: CheckoutBigButton(
        label: 'Apply',
        onTap: _apply,
        color: CC.textPri, // tombol hitam sesuai Gambar 3
      ),
    );
  }
}

// ── Single Shipping Row ───────────────────────────────────────────────────────
class _ShippingRow extends StatelessWidget {
  final ShippingMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShippingRow({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CC.divider)),
        ),
        child: Row(
          children: [
            // ── Shipping icon ──────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CC.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(method.icon, size: 22, color: CC.textPri),
            ),
            const SizedBox(width: 14),

            // ── Name + arrival ─────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CC.textPri,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Estimated Arrival  ${method.estimatedArrival}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CC.textSec,
                    ),
                  ),
                ],
              ),
            ),

            // ── Price ──────────────────────────────────────────
            Text(
              '\$${method.cost.toInt()}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: CC.textPri,
              ),
            ),
            const SizedBox(width: 16),

            // ── Radio ──────────────────────────────────────────
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
        color: Colors.white,
      ),
    );
  }
}