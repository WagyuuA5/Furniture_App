// lib/screens/struk_pembayaran_screen.dart
//
// UPDATE:
//  - Hapus tombol "Download Struk"
//  - Tambah tombol "Kembali Ke Beranda" → Navigator.pushNamedAndRemoveUntil('/home')
//  - Tambah tombol "Lacak Pesanan" (secondary) → push TrackOrderScreen
//  - Fungsi _downloadStruk tetap ada (bisa dipanggil dari icon share di header)

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/order.dart';
import 'track_order_screen.dart'; // ← halaman baru

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────
class _C {
  static const bg            = Color(0xFFF5F3EF);
  static const surface       = Color(0xFFFFFFFF);
  static const primary       = Color(0xFF1A1A1A);
  static const accent        = Color(0xFF2C5F52);
  static const accentLight   = Color(0xFFE8F4ED);
  static const textSecondary = Color(0xFF8A8A8A);
  static const divider       = Color(0xFFEEECE8);
  static const receiptShadow = Color(0x1A000000);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class StrukPembayaranScreen extends StatefulWidget {
  final OrderSummary order;
  const StrukPembayaranScreen({super.key, required this.order});

  @override
  State<StrukPembayaranScreen> createState() => _StrukPembayaranScreenState();
}

class _StrukPembayaranScreenState extends State<StrukPembayaranScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _receiptKey = GlobalKey();
  bool _sharing = false;

  late final AnimationController _fadeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _fadeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Share/download (dipindah ke icon di header) ──────────────
  Future<void> _shareStruk() async {
    setState(() => _sharing = true);
    try {
      final boundary = _receiptKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/struk_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        subject: 'Struk Pembayaran LUXE FURNISH',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal berbagi struk: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: RepaintBoundary(
                      key: _receiptKey,
                      child: _ReceiptCard(order: widget.order),
                    ),
                  ),
                ),
              ),
            ),
            // ── Bottom bar: 2 tombol ──
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  // ── Header — tambah share icon di kanan ─────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(bottom: BorderSide(color: _C.divider)),
      ),
      child: Row(
        children: [
          // Back button
          _CircleBtn(
            onTap: () => Navigator.of(context).pop(),
            icon: Icons.arrow_back_ios_new_rounded,
          ),
          // Title
          const Expanded(
            child: Text(
              'Struk pembayaran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _C.primary,
              ),
            ),
          ),
          // Share icon (fungsi download dipindah ke sini)
          _CircleBtn(
            onTap: _sharing ? () {} : _shareStruk,
            icon: _sharing
                ? Icons.hourglass_top_rounded
                : Icons.share_rounded,
            color: _C.accent,
          ),
        ],
      ),
    );
  }

  // ── Bottom bar — Kembali Ke Beranda + Lacak Pesanan ──────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tombol utama: Kembali Ke Beranda ──
          _ScaleButton(
            onTap: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (_) => false),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: _C.accent,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                'Kembali Ke Beranda',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Tombol sekunder: Lacak Pesanan ──
          _ScaleButton(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TrackOrderScreen(order: widget.order),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: _C.accentLight,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _C.accent.withOpacity(0.3)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined,
                      color: _C.accent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Lacak Pesanan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _C.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RECEIPT CARD  (tidak berubah — sama persis)
// ─────────────────────────────────────────────
class _ReceiptCard extends StatelessWidget {
  final OrderSummary order;
  const _ReceiptCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: _C.receiptShadow,
              blurRadius: 20,
              offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // ── Header teal ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: _C.accent,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  'LUXE FURNISH',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Struk Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Barcode ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: SizedBox(
              height: 64,
              width: double.infinity,
              child: CustomPaint(painter: _BarcodePainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '#${order.promoCode == '-' ? 'LUXEFURNISH' : order.promoCode.toUpperCase()}',
              style: GoogleFonts.robotoMono(
                fontSize: 10,
                color: _C.textSecondary,
                letterSpacing: 2.0,
              ),
            ),
          ),

          // ── Zigzag separator ──
          const _ZigzagDivider(),

          // ── Items ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: order.items
                  .map((item) => _ReceiptItemRow(item: item))
                  .toList(),
            ),
          ),

          const _DashedDivider(),

          // ── Detail pesanan ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              children: [
                _ReceiptDetailRow(
                    label: 'Tanggal Pesanan',
                    value: fmtDate(order.orderDate)),
                const SizedBox(height: 8),
                _ReceiptDetailRow(
                    label: 'Kode Promo',
                    value: order.promoCode.isEmpty ? '-' : order.promoCode),
                const SizedBox(height: 8),
                _ReceiptDetailRow(
                    label: 'Jenis Pengiriman',
                    value: order.shippingType),
              ],
            ),
          ),

          const _DashedDivider(),

          // ── Rincian biaya ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              children: [
                _ReceiptCostRow(
                    label: 'Jumlah',
                    value: fmtRp(order.subtotal)),
                const SizedBox(height: 8),
                _ReceiptCostRow(
                    label: 'Biaya pengiriman',
                    value: fmtRp(order.shippingFee)),
                const SizedBox(height: 8),
                _ReceiptCostRow(
                    label: 'Diskon',
                    value: order.discount == 0
                        ? 'Rp0'
                        : fmtRp(order.discount)),
                const SizedBox(height: 8),
                _ReceiptCostRow(
                    label: 'Diskon',
                    value: order.discount == 0
                        ? 'Rp0'
                        : fmtRp(order.discount)),
              ],
            ),
          ),

          const _DashedDivider(),

          // ── Total ──
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _C.primary,
                    ),
                  ),
                ),
                Text(
                  fmtRp(order.total),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _C.accent,
                  ),
                ),
              ],
            ),
          ),

          // ── Footer ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F6F2),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  'Terimakasih telah berbelanja!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _C.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'www.luxefurnish.id',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: _C.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROW WIDGETS
// ─────────────────────────────────────────────
class _ReceiptItemRow extends StatelessWidget {
  final OrderItem item;
  const _ReceiptItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Gambar produk
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 70,
              height: 70,
              color: const Color(0xFFEEECE8),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.chair_outlined,
                          size: 28,
                          color: _C.textSecondary),
                    )
                  : const Icon(Icons.chair_outlined,
                      size: 28, color: _C.textSecondary),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _C.primary,
                  ),
                ),
                Text(
                  item.category,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: _C.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${fmtRp(item.price.toDouble())} | jumlah. :${item.quantity}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _C.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptDetailRow(
      {required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: _C.textSecondary)),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _C.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptCostRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptCostRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: _C.textSecondary)),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _C.primary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CUSTOM PAINTERS
// ─────────────────────────────────────────────
class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final rng = _SimpleRng(42);
    double x = 0;
    while (x < size.width) {
      final w = 1.5 + (rng.next() % 4).toDouble();
      final gap = 1.0 + (rng.next() % 3).toDouble();
      canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      x += w + gap;
    }
  }

  @override
  bool shouldRepaint(_BarcodePainter old) => false;
}

class _SimpleRng {
  int _state;
  _SimpleRng(this._state);
  int next() {
    _state = (_state * 1664525 + 1013904223) & 0xFFFFFFFF;
    return (_state >> 16) & 0xFF;
  }
}

class _ZigzagDivider extends StatelessWidget {
  const _ZigzagDivider();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: CustomPaint(
        painter: _ZigzagPainter(),
        size: const Size(double.infinity, 16),
      ),
    );
  }
}

class _ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white);
    final path = Path();
    const step = 12.0;
    final half = size.height / 2;
    path.moveTo(0, 0);
    double x = 0;
    while (x < size.width) {
      path.lineTo(x + step / 2, half);
      path.lineTo(x + step, 0);
      x += step;
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(
        path, Paint()..color = const Color(0xFFF5F3EF));
  }

  @override
  bool shouldRepaint(_ZigzagPainter old) => false;
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: SizedBox(
          height: 1, child: CustomPaint(painter: _DashPainter())),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCCBC8)
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 6, 0), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => false;
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _ScaleButton({required this.child, required this.onTap});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100));
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.95).animate(_ctrl);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _CircleBtn(
      {required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color != null
              ? color!.withOpacity(0.12)
              : const Color(0xFFF0EDE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon,
            size: 16, color: color ?? _C.primary),
      ),
    );
  }
}