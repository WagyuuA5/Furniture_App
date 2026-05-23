// lib/screens/qris_screen.dart
//
// PERUBAHAN:
//  - Menerima OrderSummary dari PaymentMethodScreen
//  - Setelah countdown/konfirmasi selesai → push PaymentSuccessScreen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/order.dart';
import 'payment_success_screen.dart';

class QrisScreen extends StatefulWidget {
  final OrderSummary orderSummary;
  const QrisScreen({super.key, required this.orderSummary});

  @override
  State<QrisScreen> createState() => _QrisScreenState();
}

class _QrisScreenState extends State<QrisScreen> {
  static const _C = Color(0xFF2C6E49);
  int _seconds = 300; // 5 menit countdown
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeStr {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onBayarSelesai() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            PaymentSuccessScreen(order: widget.orderSummary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Color(0xFF1A1A1A)),
          ),
        ),
        title: Text('Pembayaran QRIS',
            style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── Countdown ──
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4ED),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 18, color: _C),
                  const SizedBox(width: 8),
                  Text('Bayar dalam $_timeStr',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // ── QR Code placeholder ──
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFEEECE8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomPaint(painter: _QrPainter()),
            ),
            const SizedBox(height: 20),
            Text('Scan QR di atas menggunakan\naplikasi pembayaran',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF8A8A8A))),
            const SizedBox(height: 8),
            Text(fmtRp(widget.orderSummary.total),
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _C)),
            const Spacer(),
            // ── Tombol konfirmasi (simulasi) ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onBayarSelesai,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Saya Sudah Bayar',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batalkan',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF8A8A8A))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── QR Code visual painter ────────────────────────────────────────────────────
class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), bg);

    const cell = 7.0;
    const pad = 20.0;
    const rng = 42;

    // Corner squares (finder patterns)
    _drawFinder(canvas, paint, pad, pad, cell);
    _drawFinder(canvas, paint, size.width - pad - cell * 7, pad, cell);
    _drawFinder(canvas, paint, pad, size.height - pad - cell * 7, cell);

    // Random data dots
    final r = _SimpleRng(rng);
    for (double y = pad; y < size.height - pad; y += cell) {
      for (double x = pad; x < size.width - pad; x += cell) {
        // Skip finder pattern areas
        if ((x < pad + cell * 8 && y < pad + cell * 8) ||
            (x > size.width - pad - cell * 8 && y < pad + cell * 8) ||
            (x < pad + cell * 8 && y > size.height - pad - cell * 8)) {
          continue;
        }
        if (r.next() % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(x + 1, y + 1, cell - 2, cell - 2),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(
      Canvas canvas, Paint paint, double x, double y, double cell) {
    // Outer
    canvas.drawRect(
        Rect.fromLTWH(x, y, cell * 7, cell * 7), paint);
    canvas.drawRect(
        Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
        Paint()..color = Colors.white);
    // Inner
    canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        paint);
  }

  @override
  bool shouldRepaint(_QrPainter old) => false;
}

class _SimpleRng {
  int _state;
  _SimpleRng(this._state);
  int next() {
    _state = (_state * 1664525 + 1013904223) & 0xFFFFFFFF;
    return (_state >> 16) & 0xFF;
  }
}