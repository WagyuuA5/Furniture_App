// lib/screens/success_screen.dart
// Halaman sukses pembayaran (COD / Transfer)
// - Icon centang animasi
// - "Pembayaran Sukses"
// - "Terimakasih Atas pembelian anda"
// - Tombol "Kembali Ke Beranda" → pushAndRemoveUntil HomeScreen
// - Tombol "Lihat Pesanan" → StrukPembayaranScreen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import '../models/order.dart';
import 'struk_pembayaran_screen.dart';

class SuccessScreen extends StatefulWidget {
  final OrderSummary orderSummary;
  const SuccessScreen({super.key, required this.orderSummary});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  static const _teal    = Color(0xFF2C6E49);
  static const _textPri = Color(0xFF1A1A1A);
  static const _textSec = Color(0xFF8A8A8A);
  static const _divider = Color(0xFFEEECE8);
  static const _bg      = Color(0xFFFAFAFA);

  late AnimationController _ctrl;
  late Animation<double>   _scale;
  late Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _ctrl.forward();

    // Kosongkan cart setelah bayar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().clear();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _divider),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: _textPri),
          ),
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _textPri,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _divider),
        ),
      ),
      body: Column(
        children: [
          // ── Konten tengah ────────────────────────────────────────────────
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lingkaran centang animasi
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: _teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Teks sukses
                  FadeTransition(
                    opacity: _fade,
                    child: const Column(
                      children: [
                        Text(
                          'Pembayaran Sukses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _textPri,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Terimakasih Atas pembelian anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSec,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tombol bawah ─────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Kembali Ke Beranda
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Kembali Ke Beranda',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tombol Lihat Pesanan → navigasi ke StrukPembayaranScreen
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StrukPembayaranScreen(
                            order: widget.orderSummary,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textPri,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}