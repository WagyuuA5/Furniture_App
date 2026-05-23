// lib/screens/track_order_screen.dart
//
// Halaman Detail Pesanan / Track Order
// Desain 1:1 sesuai gambar 2

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/order.dart';

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
  static const done          = Color(0xFF2C5F52);   // lingkaran selesai
  static const pending       = Color(0xFFCCCCCC);   // lingkaran belum
}

// ─────────────────────────────────────────────
// MODEL STATUS
// ─────────────────────────────────────────────
class _OrderStatus {
  final String label;
  final String date;
  final bool isDone;
  const _OrderStatus(
      {required this.label, required this.date, required this.isDone});
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class TrackOrderScreen extends StatefulWidget {
  final OrderSummary order;
  const TrackOrderScreen({super.key, required this.order});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

  // Data status timeline — hardcode sesuai gambar
  // Bisa diganti dengan data dari OrderSummary jika sudah ada di model
  final List<_OrderStatus> _statuses = const [
    _OrderStatus(
        label: 'Pesanan Dibuat',
        date: '08 September 2026',
        isDone: true),
    _OrderStatus(
        label: 'Pesanan Diproses',
        date: '09 September 2026',
        isDone: true),
    _OrderStatus(
        label: 'Pesanan Dikirim',
        date: '10 September 2026',
        isDone: true),
    _OrderStatus(
        label: 'Pesanan Selesai',
        date: '11 September 2026',
        isDone: false),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100),
        () { if (mounted) _fadeCtrl.forward(); });
  }

  @override
  void dispose() {
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
              child: FadeTransition(
                opacity: _fade,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    children: [
                      // ── Barcode ──
                      _BarcodeCard(),
                      const SizedBox(height: 16),

                      // ── Kartu putih: item + detail + biaya + status ──
                      _MainCard(
                        order: widget.order,
                        statuses: _statuses,
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(bottom: BorderSide(color: _C.divider)),
      ),
      child: Row(
        children: [
          _CircleBtn(
              onTap: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back_ios_new_rounded),
          const Expanded(
            child: Text(
              'Detail Pesanan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _C.primary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

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
      child: _ScaleButton(
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
    );
  }
}

// ─────────────────────────────────────────────
// BARCODE CARD
// ─────────────────────────────────────────────
class _BarcodeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            width: double.infinity,
            child: CustomPaint(painter: _BarcodePainter()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN CARD (konten utama setelah barcode)
// ─────────────────────────────────────────────
class _MainCard extends StatelessWidget {
  final OrderSummary order;
  final List<_OrderStatus> statuses;
  const _MainCard(
      {required this.order, required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label section ──
          _SectionLabel('Detail Pesanan'),

          // ── Item list ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: order.items
                  .map((item) => _TrackItemRow(item: item))
                  .toList(),
            ),
          ),

          _HDivider(),

          // ── Info order ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                _InfoRow('Tanggal Order', fmtDate(order.orderDate)),
                const SizedBox(height: 8),
                _InfoRow('Kode Promo',
                    order.promoCode.isEmpty ? '-' : order.promoCode),
                const SizedBox(height: 8),
                _InfoRow('Jenis Pengiriman', order.shippingType),
                const SizedBox(height: 8),
                _InfoRow('Pesanan Tiba', '08 Mei 2026'),
              ],
            ),
          ),

          _HDivider(),

          // ── Rincian harga ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                _CostRow('Jumlah', fmtRp(order.subtotal)),
                const SizedBox(height: 8),
                _CostRow('Biaya pengiriman', fmtRp(order.shippingFee)),
                const SizedBox(height: 8),
                _CostRow('Diskon',
                    order.discount == 0
                        ? 'Rp0'
                        : fmtRp(order.discount)),
                const SizedBox(height: 8),
                _CostRow('Diskon',
                    order.discount == 0
                        ? 'Rp0'
                        : fmtRp(order.discount)),
                const SizedBox(height: 12),
                // Total
                Row(
                  children: [
                    Expanded(
                      child: Text('Total',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _C.primary)),
                    ),
                    Text(fmtRp(order.total),
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _C.accent)),
                  ],
                ),
              ],
            ),
          ),

          _HDivider(),

          // ── Status Order ──
          _SectionLabel('Status Order'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _StatusTimeline(statuses: statuses),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TRACK ITEM ROW
// ─────────────────────────────────────────────
class _TrackItemRow extends StatelessWidget {
  final OrderItem item;
  const _TrackItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFEEECE8),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.chair_outlined,
                          size: 28,
                          color: _C.textSecondary))
                  : const Icon(Icons.chair_outlined,
                      size: 28, color: _C.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _C.primary)),
                Text(item.category,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: _C.textSecondary)),
                const SizedBox(height: 3),
                Text(
                    '${fmtRp(item.price.toDouble())} | jumlah. :${item.quantity}',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
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
// STATUS TIMELINE
// ─────────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final List<_OrderStatus> statuses;
  const _StatusTimeline({required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(statuses.length, (i) {
        final s = statuses[i];
        final isLast = i == statuses.length - 1;
        return _TimelineItem(
          status: s,
          isLast: isLast,
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final _OrderStatus status;
  final bool isLast;
  const _TimelineItem({required this.status, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Kolom kiri: lingkaran + garis ──
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Lingkaran
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: status.isDone
                        ? _C.done
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status.isDone
                          ? _C.done
                          : _C.pending,
                      width: 2,
                    ),
                  ),
                  child: status.isDone
                      ? const Icon(Icons.check_rounded,
                          size: 15, color: Colors.white)
                      : null,
                ),
                // Garis vertikal (kecuali item terakhir)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _C.divider,
                      margin:
                          const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Kolom kanan: label + tanggal + icon ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status.label,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: status.isDone
                                ? _C.primary
                                : _C.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status.date,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _C.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icon di kanan sesuai status
                  _StatusIcon(status: status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Icon kanan tiap status (sesuai gambar)
class _StatusIcon extends StatelessWidget {
  final _OrderStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (status.label) {
      case 'Pesanan Dibuat':
        icon = Icons.receipt_long_outlined;
        break;
      case 'Pesanan Diproses':
        icon = Icons.inventory_2_outlined;
        break;
      case 'Pesanan Dikirim':
        icon = Icons.local_shipping_outlined;
        break;
      case 'Pesanan Selesai':
        icon = Icons.check_box_outlined;
        break;
      default:
        icon = Icons.circle_outlined;
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: status.isDone
            ? _C.accentLight
            : const Color(0xFFF0EFED),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 18,
        color:
            status.isDone ? _C.done : _C.textSecondary,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HELPER ROW WIDGETS
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

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
          child: Text(value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _C.primary)),
        ),
      ],
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  const _CostRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: _C.textSecondary)),
        ),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.primary)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Text(text,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _C.primary)),
    );
  }
}

class _HDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(color: _C.divider, thickness: 1, height: 1);
}

// ─────────────────────────────────────────────
// BARCODE PAINTER
// ─────────────────────────────────────────────
class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final rng = _SimpleRng(99);
    double x = 0;
    while (x < size.width) {
      final w = 1.5 + (rng.next() % 4).toDouble();
      final gap = 1.0 + (rng.next() % 3).toDouble();
      canvas.drawRect(
          Rect.fromLTWH(x, 0, w, size.height), paint);
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
        child:
            Icon(icon, size: 16, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}