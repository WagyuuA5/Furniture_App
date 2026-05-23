// lib/screens/coupon_screen.dart
//
// Halaman Coupon & Diskon — desain tiket/kwitansi
// Fitur:
//  - Filter tab: Semua / Tersedia / Terkunci
//  - Status: available, locked, used
//  - Tombol COPY CODE dengan animasi SnackBar
//  - Callback onApply → dipakai oleh PaymentMethodScreen (opsional)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// MODEL KUPON
// ─────────────────────────────────────────────
enum CouponStatus { available, locked, used }

class CouponModel {
  final String code;
  final String subtitle;
  final String benefit;
  final CouponStatus status;
  final IconData icon;

  const CouponModel({
    required this.code,
    required this.subtitle,
    required this.benefit,
    required this.status,
    this.icon = Icons.local_offer_rounded,
  });
}

// ─────────────────────────────────────────────
// DATA KUPON (12 buah)
// ─────────────────────────────────────────────
const List<CouponModel> kAllCoupons = [
  CouponModel(
    code: 'WELCOME200',
    subtitle: 'Add items worth Rp2.000 more to unlock',
    benefit: 'Get 50% OFF',
    status: CouponStatus.available,
    icon: Icons.celebration_rounded,
  ),
  CouponModel(
    code: 'CASHBACK12',
    subtitle: 'Add items worth Rp2.000 more to unlock',
    benefit: 'Up to Rp12.000 cashback',
    status: CouponStatus.available,
    icon: Icons.account_balance_wallet_rounded,
  ),
  CouponModel(
    code: 'FEST2COST',
    subtitle: 'Add items worth Rp28.000 more to unlock',
    benefit: 'Get 50% OFF for Combo',
    status: CouponStatus.locked,
    icon: Icons.local_fire_department_rounded,
  ),
  CouponModel(
    code: 'DISKON10',
    subtitle: 'Berlaku untuk semua produk',
    benefit: 'Diskon 10% untuk semua produk',
    status: CouponStatus.available,
    icon: Icons.percent_rounded,
  ),
  CouponModel(
    code: 'NEWUSER50',
    subtitle: 'Khusus pengguna baru',
    benefit: 'Diskon 50% untuk pembelian pertama',
    status: CouponStatus.available,
    icon: Icons.person_add_rounded,
  ),
  CouponModel(
    code: 'FLASHSALE',
    subtitle: 'Add items worth Rp50.000 more to unlock',
    benefit: 'Flash Sale: Hemat Rp75.000',
    
    status: CouponStatus.locked,
    icon: Icons.flash_on_rounded,
  ),
  CouponModel(
    code: 'FREESHIP',
    subtitle: 'Min. pembelian Rp200.000',
    benefit: 'Gratis ongkos kirim ke seluruh Indonesia',
    status: CouponStatus.available,
    icon: Icons.local_shipping_rounded,
  ),
  CouponModel(
    code: 'LUXURY25',
    subtitle: 'Khusus produk kategori Premium',
    benefit: 'Diskon 25% produk Luxury',
    status: CouponStatus.available,
    icon: Icons.diamond_rounded,
  ),
  CouponModel(
    code: 'WEEKEND30',
    subtitle: 'Berlaku Sabtu & Minggu saja',
    benefit: 'Weekend Special: 30% OFF',
    status: CouponStatus.locked,
    icon: Icons.weekend_rounded,
  ),
  CouponModel(
    code: 'PAYDAY25',
    subtitle: 'Min belanja Rp200.000',
    benefit: '25% OFF',
    status: CouponStatus.available,
    icon: Icons.payments_rounded,
  ),
  CouponModel(
    code: 'BIRTHDAY30',
    subtitle: 'Hadiah spesial ulang tahun kamu',
    benefit: '30% OFF maks Rp80.000',
    status: CouponStatus.locked,
    icon: Icons.cake_rounded,
  ),
  CouponModel(
    code: 'MEMBER15',
    subtitle: 'Sudah digunakan pada pesanan sebelumnya',
    benefit: 'Member Exclusive 15% OFF',
    status: CouponStatus.used,
    icon: Icons.card_membership_rounded,
  ),
];

// ─────────────────────────────────────────────
// THEME LOKAL
// ─────────────────────────────────────────────
class _C {
  static const bg          = Color(0xFFF7F6F3);
  static const surface     = Color(0xFFFFFFFF);
  static const primary     = Color(0xFF1A1A1A);
  static const accent      = Color(0xFF2C5F52);
  static const textSec     = Color(0xFF8A8A8A);
  static const divider     = Color(0xFFEEECE8);
  static const locked      = Color(0xFFB0B0B0);
  static const lockedBg    = Color(0xFFF0F0F0);
  static const used        = Color(0xFFCCCCCC);
  static const usedBg      = Color(0xFFF5F5F5);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class CouponScreen extends StatefulWidget {
  /// Callback saat user memilih kupon — null jika layar dibuka standalone
  final void Function(String code)? onApply;

  const CouponScreen({super.key, this.onApply});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl =
      TabController(length: 3, vsync: this);
  String? _copiedCode;

  List<CouponModel> _filtered(int tab) {
    switch (tab) {
      case 1:
        return kAllCoupons
            .where((c) => c.status == CouponStatus.available)
            .toList();
      case 2:
        return kAllCoupons
            .where((c) => c.status == CouponStatus.locked)
            .toList();
      default:
        return kAllCoupons;
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    setState(() => _copiedCode = code);
    Future.delayed(
      const Duration(seconds: 2),
      () { if (mounted) setState(() => _copiedCode = null); },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text('Kode "$code" berhasil disalin!',
              style: GoogleFonts.poppins(fontSize: 13)),
        ]),
        backgroundColor: _C.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Jika dipanggil dari PaymentMethodScreen → apply & pop
    if (widget.onApply != null) {
      widget.onApply!(code);
      Navigator.of(context).pop(code);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
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
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: List.generate(3, (tab) {
                  final list = _filtered(tab);
                  return _buildList(list);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────
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
            icon: Icons.arrow_back_ios_new_rounded,
          ),
          Expanded(
            child: Text(
              'Coupon',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _C.primary,
              ),
            ),
          ),
          // badge jumlah kupon tersedia
          Container(
            width: 40,
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _C.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${kAllCoupons.where((c) => c.status == CouponStatus.available).length}',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _C.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab bar ──────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: _C.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TabBar(
        controller: _tabCtrl,
        labelColor: _C.accent,
        unselectedLabelColor: _C.textSec,
        indicatorColor: _C.accent,
        indicatorWeight: 2.5,
        labelStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Tersedia'),
          Tab(text: 'Terkunci'),
        ],
      ),
    );
  }

  // ── List kupon ───────────────────────────────
  Widget _buildList(List<CouponModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_offer_outlined, size: 48, color: _C.textSec),
            const SizedBox(height: 12),
            Text('Tidak ada kupon',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: _C.textSec)),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          'Best offers for you',
          style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _C.primary),
        ),
        const SizedBox(height: 14),
        ...list.map((c) => _CouponCard(
              coupon: c,
              isCopied: _copiedCode == c.code,
              onCopy: () => _copyCode(c.code),
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// COUPON CARD  (desain tiket/kwitansi)
// ─────────────────────────────────────────────
class _CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final bool isCopied;
  final VoidCallback onCopy;

  const _CouponCard({
    required this.coupon,
    required this.isCopied,
    required this.onCopy,
  });

  bool get _isLocked => coupon.status == CouponStatus.locked;
  bool get _isUsed   => coupon.status == CouponStatus.used;
  bool get _isActive => coupon.status == CouponStatus.available;

  Color get _cardBg => _isUsed
      ? const Color(0xFFF5F5F5)
      : _isLocked
          ? const Color(0xFFF0F0F0)
          : _C.surface;

  Color get _accentColor => _isActive
      ? _C.accent
      : _isLocked
          ? const Color(0xFFB0B0B0)
          : const Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _TicketShape(
        color: _cardBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Konten atas ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(coupon.icon, size: 18, color: _accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kode + badge status
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                coupon.code,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: _isActive
                                      ? _C.primary
                                      : _accentColor,
                                ),
                              ),
                            ),
                            if (_isUsed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCCCCCC)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFCCCCCC),
                                      width: 1),
                                ),
                                child: Text('Terpakai',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFFCCCCCC),
                                        fontWeight: FontWeight.w600)),
                              ),
                            if (_isLocked)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Terkunci',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        // Subtitle
                        Text(
                          coupon.subtitle,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: _C.textSec),
                        ),
                        const SizedBox(height: 8),
                        // Benefit
                        Row(
                          children: [
                            Icon(
                              _isLocked
                                  ? Icons.lock_outline_rounded
                                  : _isUsed
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.verified_rounded,
                              size: 15,
                              color: _accentColor,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                coupon.benefit,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _isActive
                                      ? _C.primary
                                      : _accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Garis dashed separator ──
            _DashedSeparator(color: _accentColor.withOpacity(0.25)),

            // ── Tombol COPY CODE ──
            _CopyButton(
              isActive: _isActive,
              isCopied: isCopied,
              isUsed: _isUsed,
              isLocked: _isLocked,
              accentColor: _accentColor,
              onCopy: onCopy,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// COPY BUTTON
// ─────────────────────────────────────────────
class _CopyButton extends StatelessWidget {
  final bool isActive;
  final bool isCopied;
  final bool isUsed;
  final bool isLocked;
  final Color accentColor;
  final VoidCallback onCopy;

  const _CopyButton({
    required this.isActive,
    required this.isCopied,
    required this.isUsed,
    required this.isLocked,
    required this.accentColor,
    required this.onCopy,
  });

  String get _label {
    if (isCopied) return '✓  KODE DISALIN';
    if (isUsed) return 'SUDAH DIGUNAKAN';
    if (isLocked) return 'TERKUNCI';
    return 'COPY CODE';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive && !isCopied ? onCopy : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isCopied
              ? _C.accent.withOpacity(0.08)
              : const Color(0xFFF5F4F2),
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16)),
        ),
        child: Text(
          _label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isCopied
                ? _C.accent
                : isActive
                    ? _C.textSec
                    : accentColor,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TICKET SHAPE
// ─────────────────────────────────────────────
class _TicketShape extends StatelessWidget {
  final Widget child;
  final Color color;

  const _TicketShape({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DASHED SEPARATOR
// ─────────────────────────────────────────────
class _DashedSeparator extends StatelessWidget {
  final Color color;

  const _DashedSeparator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6F3),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 1,
              child: CustomPaint(
                  painter: _DashPainter(color: color)),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6F3),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 5, 0), paint);
      x += 9;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}

// ─────────────────────────────────────────────
// CIRCLE BUTTON
// ─────────────────────────────────────────────
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