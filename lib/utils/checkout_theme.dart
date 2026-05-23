// checkout/checkout_theme.dart
// Konstanta warna, teks, dan helper yang dipakai di semua screen checkout

import 'package:flutter/material.dart';

class CC {
  // Colors (sesuai desain pixel-perfect)
  static const bg         = Color(0xFFFAFAFA);
  static const surface    = Color(0xFFFFFFFF);
  static const teal       = Color(0xFF2C6E49);
  static const textPri    = Color(0xFF1A1A1A);
  static const textSec    = Color(0xFF8A8A8A);
  static const divider    = Color(0xFFEEECE8);
  static const border     = Color(0xFFE0DDD8);
  static const radioOff   = Color(0xFFCCCCCC);
}

// ── Reusable "CHANGE" button ──────────────────────────────────────────────────
class ChangeButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const ChangeButton({super.key, required this.onTap, this.label = 'CHANGE'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: CC.textSec,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Big Apply / Continue button ───────────────────────────────────────────────
class CheckoutBigButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const CheckoutBigButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = CC.teal,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: CC.textPri,
      ),
    );
  }
}

// ── Custom AppBar shared ──────────────────────────────────────────────────────
PreferredSizeWidget checkoutAppBar(BuildContext context, String title) => AppBar(
      backgroundColor: CC.surface,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CC.bg,
            shape: BoxShape.circle,
            border: Border.all(color: CC.border),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: CC.textPri),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: CC.textPri,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: CC.divider),
      ),
    );

// ── Format price helper ───────────────────────────────────────────────────────
String formatUSD(double price) => '\$${price.toStringAsFixed(2)}';