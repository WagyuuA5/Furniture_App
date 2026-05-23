// screens/product_detail_screen.dart
// Detail Produk — updated: integrasi Rating & Review
// Mempertahankan: CartProvider, Hero animation, Thumbnail Gallery,
//                 AnimationController, Google Fonts, AppColors/AppRadius/AppShadows

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../models/product.dart';
import '../widgets/rating_widget.dart';
import '../widgets/product_thumbnail.dart';
import 'cart_screen.dart';          // CartProvider + CartItem
import 'rating_screen.dart';        // halaman daftar review
import 'leave_review_screen.dart';  // halaman tulis review

// ============================================================
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _thumbIndex = 0;

  late final AnimationController _contentCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );
  late final Animation<double> _contentFade =
      Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));
  late final Animation<Offset> _contentSlide =
      Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  // ── Format harga ──────────────────────────────────────────────
  String _fmt(double price) {
    if (price >= 1000000) {
      final v = price / 1000000;
      return 'Rp ${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)} Juta';
    }
    final s = price.toInt().toString();
    final b = StringBuffer('Rp ');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }

  String get _currentImage {
    if (_thumbIndex == 0) return widget.product.imageUrl;
    if (_thumbIndex < widget.product.thumbnails.length) {
      return widget.product.thumbnails[_thumbIndex];
    }
    return widget.product.imageUrl;
  }

  // ── Cart helpers ──────────────────────────────────────────────
  void _addToCart(BuildContext context) {
    context.read<CartProvider>().addItem(
          CartItem.fromProduct(widget.product),
        );
  }

  void _showAddedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.product.name} ditambahkan ke keranjang',
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2C6E49),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Lihat',
          textColor: Colors.white,
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ),
    );
  }

  // ── NEW: Navigasi ke halaman semua review ─────────────────────
  void _goToReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RatingScreen(product: widget.product),
      ),
    ).then((_) => setState(() {})); // refresh rating setelah kembali
  }

  // ── NEW: Navigasi ke halaman tulis review ─────────────────────
  void _goToLeaveReview() async {
    final submitted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveReviewScreen(product: widget.product),
      ),
    );
    if (submitted == true) setState(() {}); // refresh preview review
  }

  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context),

                  // ── Hero image ──────────────────────────────
                  Hero(
                    tag: 'product_${widget.product.id}',
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      color: AppColors.softGray,
                      child: Image.network(
                        _currentImage,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.chair_rounded,
                              size: 100, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),

                  // ── Content (fade + slide in) ───────────────
                  FadeTransition(
                    opacity: _contentFade,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildThumbnails(),
                            const SizedBox(height: 20),

                            // ── Nama produk + rating tap ──────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.product.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // ← NEW: tap rating → buka RatingScreen
                                GestureDetector(
                                  onTap: _goToReviews,
                                  child: RatingWidget(
                                    rating: widget.product.rating,
                                    starSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // ── NEW: Review count + shortcut ──
                            GestureDetector(
                              onTap: _goToReviews,
                              child: Row(
                                children: [
                                  Text(
                                    '${widget.product.reviewCount} ulasan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right,
                                      size: 16, color: AppColors.textSecondary),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Deskripsi produk ──────────────
                            Text(
                              'Detail Produk',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.product.description,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.75),
                            ),

                            const SizedBox(height: 24),

                            // ── Harga ─────────────────────────
                            Text(
                              'Harga',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _fmt(widget.product.price),
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkTeal),
                            ),
                            if (widget.product.oldPrice != null)
                              Text(
                                _fmt(widget.product.oldPrice!),
                                style: AppTextStyles.priceOld
                                    .copyWith(fontSize: 13),
                              ),

                            // ── NEW: Review Section ───────────
                            const SizedBox(height: 28),
                            _buildReviewSection(),

                            // Spacer agar tidak tertutup bottom bar
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Floating bottom bar ─────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: AppColors.softGray, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: Text(
              'Detail Produk',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
          ),
          // Cart icon dengan badge
          GestureDetector(
            onTap: () {
              _addToCart(context);
              Navigator.of(context).pushNamed('/cart');
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.softGray, shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_cart_outlined,
                      size: 20, color: AppColors.textPrimary),
                ),
                Consumer<CartProvider>(
                  builder: (_, cart, __) {
                    if (cart.totalCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C6E49),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalCount}',
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Thumbnail Gallery ─────────────────────────────────────────
  Widget _buildThumbnails() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.thumbnails.length,
        itemBuilder: (_, i) => ProductThumbnail(
          imageUrl: widget.product.thumbnails[i],
          isSelected: _thumbIndex == i,
          onTap: () => setState(() => _thumbIndex = i),
        ),
      ),
    );
  }

  // ── NEW: Review Preview Section ───────────────────────────────
  Widget _buildReviewSection() {
    final reviews = widget.product.reviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header baris: "Reviews (n)" + "Lihat Semua"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${widget.product.reviewCount})',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: _goToReviews,
              child: Text(
                'Lihat Semua',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTeal,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Rating summary bar (mini)
        _buildRatingSummary(),

        const SizedBox(height: 16),

        // Preview max 2 review terbaru
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Belum ada review. Jadilah yang pertama!',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
          )
        else
          ...reviews.take(2).map((r) => _buildReviewCard(r)),

        const SizedBox(height: 12),

        // Tombol Tulis Review
        OutlinedButton.icon(
          onPressed: _goToLeaveReview,
          icon: const Icon(Icons.rate_review_outlined, size: 16),
          label: Text(
            'Tulis Review',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkTeal,
            side: const BorderSide(color: AppColors.darkTeal, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  // ── NEW: Mini rating summary (angka besar + bar) ──────────────
  Widget _buildRatingSummary() {
    final rating = widget.product.rating;
    final reviews = widget.product.reviews;

    // Hitung distribusi bintang dari data review yang ada
    final Map<int, int> starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final star = r.rating.round().clamp(1, 5);
      starCounts[star] = (starCounts[star] ?? 0) + 1;
    }
    final maxCount =
        starCounts.values.fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Angka rating besar
          Column(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              RatingWidget(rating: rating, starSize: 12),
              const SizedBox(height: 4),
              Text(
                '${widget.product.reviewCount} ulasan',
                style: GoogleFonts.poppins(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Bar distribusi bintang
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = starCounts[star] ?? 0;
                final ratio = maxCount == 0 ? 0.0 : count / maxCount;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.darkTeal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── NEW: Single review card ────────────────────────────────────
  Widget _buildReviewCard(Review r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + nama + waktu
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.darkTeal.withOpacity(0.15),
                  child: Text(
                    r.userName.isNotEmpty ? r.userName[0].toUpperCase() : '?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.darkTeal,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.userName,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        r.timeAgo,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bintang kecil di kanan
                RatingWidget(rating: r.rating, starSize: 12),
              ],
            ),
            const SizedBox(height: 10),
            // Komentar
            Text(
              r.comment,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Action Bar ─────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.navbarBg,
        borderRadius: BorderRadius.circular(AppRadius.bottomNavbar),
        boxShadow: AppShadows.navbar,
      ),
      child: Row(
        children: [
          // Tambah ke keranjang (tanpa pindah halaman)
          GestureDetector(
            onTap: () {
              _addToCart(context);
              _showAddedSnack(context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          // Beli Sekarang → addItem + ke /checkout
          Expanded(
            child: GestureDetector(
              onTap: () {
                _addToCart(context);
                Navigator.of(context).pushNamed('/checkout');
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.darkTeal,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Beli Sekarang',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}