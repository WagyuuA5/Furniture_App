// lib/screens/payment_success_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import dari order_model.dart — bukan dari diri sendiri
import '../models/order.dart';
import 'struk_pembayaran_screen.dart';

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1A1A1A);
  static const accent = Color(0xFF2C5F52);
  static const textSecondary = Color(0xFF8A8A8A);
  static const divider = Color(0xFFEEECE8);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class PaymentSuccessScreen extends StatefulWidget {
  final OrderSummary order;
  const PaymentSuccessScreen({super.key, required this.order});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 750));
  late final AnimationController _fadeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));

  late final Animation<double> _checkScale =
      CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);
  late final Animation<double> _checkDraw = CurvedAnimation(
      parent: _checkCtrl,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut));
  late final Animation<double> _contentFade =
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  late final Animation<Offset> _contentSlide =
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _checkCtrl.forward().then((_) {
          if (mounted) _fadeCtrl.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    // ── Animated checkmark ──
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: _C.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2C5F52).withOpacity(0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _checkDraw,
                          builder: (_, __) => CustomPaint(
                            painter: _CheckPainter(progress: _checkDraw.value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    // ── Teks sukses ──
                    FadeTransition(
                      opacity: _contentFade,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: Column(
                          children: [
                            Text('Pembayaran Sukses',
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: _C.primary)),
                            const SizedBox(height: 6),
                            Text('Terimakasih Atas pembelian anda',
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: _C.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // ── Konten order ──
                    FadeTransition(
                      opacity: _contentFade,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.order.items
                                .map((item) => _OrderItemRow(item: item)),
                            const _HDivider(),
                            _DetailSection(order: widget.order),
                            const _HDivider(),
                            _CostSection(order: widget.order, showTotal: true),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Bottom buttons ──
            _BottomButtons(
              primaryLabel: 'Kembali Ke Beranda',
              secondaryLabel: 'Lihat Pesanan',
              onPrimary: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (_) => false),
              onSecondary: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      StrukPembayaranScreen(order: widget.order),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: _C.surface,
      child: Row(
        children: [
          _CircleBtn(
              onTap: () => Navigator.of(context).maybePop(),
              icon: Icons.arrow_back_ios_new_rounded),
          Expanded(
            child: Text('Pembayaran',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _C.primary)),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHECK PAINTER
// ─────────────────────────────────────────────
class _CheckPainter extends CustomPainter {
  final double progress;
  _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final pts = [
      Offset(cx - 18, cy + 1),
      Offset(cx - 5, cy + 14),
      Offset(cx + 18, cy - 13),
    ];

    double totalLen = 0;
    for (int i = 0; i < pts.length - 1; i++) {
      totalLen += (pts[i + 1] - pts[i]).distance;
    }
    double rem = totalLen * progress;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final seg = pts[i + 1] - pts[i];
      final segLen = seg.distance;
      if (rem <= 0) break;
      if (rem >= segLen) {
        path.lineTo(pts[i + 1].dx, pts[i + 1].dy);
        rem -= segLen;
      } else {
        final t = rem / segLen;
        path.lineTo(pts[i].dx + seg.dx * t, pts[i].dy + seg.dy * t);
        rem = 0;
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
// ORDER ITEM ROW
// ─────────────────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 76,
              height: 76,
              color: const Color(0xFFEEECE8),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.chair_outlined,
                          size: 32, color: _C.textSecondary))
                  : const Icon(Icons.chair_outlined,
                      size: 32, color: _C.textSecondary),
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
                        color: _C.primary)),
                const SizedBox(height: 2),
                Text(item.category,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: _C.textSecondary)),
                const SizedBox(height: 4),
                Text('${fmtRp(item.price)} | jumlah. :${item.quantity}',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _C.primary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DETAIL SECTION
// ─────────────────────────────────────────────
class _DetailSection extends StatelessWidget {
  final OrderSummary order;
  const _DetailSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          _DetailRow(
              label: 'Tanggal Pesanan', value: fmtDate(order.orderDate)),
          const SizedBox(height: 10),
          _DetailRow(label: 'Kode Promo', value: order.promoCode),
          const SizedBox(height: 10),
          _DetailRow(label: 'Jenis Pengiriman', value: order.shippingType),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: _C.textSecondary)),
        ),
        Expanded(
          flex: 5,
          child: Text(value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _C.primary)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// COST SECTION
// ─────────────────────────────────────────────
class _CostSection extends StatelessWidget {
  final OrderSummary order;
  final bool showTotal;
  const _CostSection({required this.order, this.showTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          _CostRow(label: 'Jumlah', value: fmtRp(order.subtotal)),
          const SizedBox(height: 10),
          _CostRow(
              label: 'Biaya pengiriman', value: fmtRp(order.shippingFee)),
          const SizedBox(height: 10),
          _CostRow(label: 'Diskon', value: fmtRp(order.discount)),
          const SizedBox(height: 10),
          _CostRow(label: 'Diskon', value: fmtRp(order.discount)),
          if (showTotal) ...[
            const SizedBox(height: 12),
            const Divider(color: _C.divider, thickness: 1, height: 1),
            const SizedBox(height: 12),
            _CostRow(
                label: 'Total',
                value: fmtRp(order.total),
                isTotal: true),
          ],
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _CostRow(
      {required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: isTotal ? 14 : 13,
                  fontWeight:
                      isTotal ? FontWeight.w700 : FontWeight.w400,
                  color: isTotal ? _C.primary : _C.textSecondary)),
        ),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: isTotal ? 15 : 13,
                fontWeight:
                    isTotal ? FontWeight.w700 : FontWeight.w500,
                color: _C.primary)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM BUTTONS
// ─────────────────────────────────────────────
class _BottomButtons extends StatelessWidget {
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  const _BottomButtons({
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScaleButton(
            onTap: onPrimary,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                  color: _C.accent,
                  borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              child: Text(primaryLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 10),
            _ScaleButton(
              onTap: onSecondary!,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(secondaryLabel!,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _C.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: _C.primary)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCALE BUTTON
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
      vsync: this, duration: const Duration(milliseconds: 100));
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

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _HDivider extends StatelessWidget {
  const _HDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(color: _C.divider, thickness: 1, height: 1);
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 16, color: _C.primary),
      ),
    );
  }
}