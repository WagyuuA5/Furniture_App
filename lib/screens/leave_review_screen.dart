// screens/leave_review_screen.dart
// Halaman "Leave Review" / tulis komentar – sesuai desain Gambar 2

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/app_theme.dart';
import '../widgets/rating_widget.dart';

class LeaveReviewScreen extends StatefulWidget {
  final ProductModel product;

  const LeaveReviewScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _addedPhotos = []; // simulasi foto

  String get _ratingLabel => getRatingLabel(_selectedRating);

  String _displayPrice(double price) {
    if (price >= 10000) {
      return 'Rp${_fmt(price.toInt())}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _submitReview() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Silakan berikan rating bintang terlebih dahulu.')),
      );
      return;
    }

    final newReview = Review(
      userName: 'Anda',
      comment: _reviewController.text.trim().isEmpty
          ? '(Tidak ada komentar)'
          : _reviewController.text.trim(),
      rating: _selectedRating.toDouble(),
      timeAgo: 'Baru saja',
    );

    // Update produk (di memory)
    widget.product.reviews.insert(0, newReview);
    widget.product.reviewCount += 1;
    // Recalculate average rating (simple average)
    final total =
        widget.product.reviews.fold(0.0, (sum, r) => sum + r.rating);
    widget.product.rating = double.parse(
        (total / widget.product.reviews.length).toStringAsFixed(1));

    Navigator.pop(context, true); // true = review submitted
  }

  void _simulateAddPhoto() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Foto'),
        content: const Text(
            'Fitur upload foto akan tersedia setelah integrasi dengan image picker. Simulasi: foto berhasil ditambahkan!'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _addedPhotos.add('photo_${_addedPhotos.length + 1}'));
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.chipUnselected,
            ),
            child: const Icon(Icons.arrow_back, size: 18),
          ),
        ),
        title: const Text('Leave Review'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Product Info Card ───────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Product thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: AppColors.chipUnselected,
                              child: const Icon(Icons.image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.product.category} | Qty. : 02 pcs',
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textGrey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _displayPrice(widget.product.price),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        // Re-Order button
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Re-Order berhasil!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Re-Order',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── How is your order? ──────────────────────────────────
                  const Center(
                    child: Text(
                      'How is your order?',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Star Rating ─────────────────────────────────────────
                  const Center(
                    child: Text(
                      'Your overall rating',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textGrey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: RatingWidget(
                      initialRating: _selectedRating,
                      size: 44,
                      onRatingChanged: (r) => setState(() => _selectedRating = r),
                    ),
                  ),

                  if (_selectedRating > 0) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _ratingLabel,
                          key: ValueKey(_selectedRating),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ─── Detailed Review ─────────────────────────────────────
                  const Text(
                    'Add detailed review',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Enter here',
                        hintStyle: TextStyle(color: AppColors.textGrey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Add Photo ───────────────────────────────────────────
                  GestureDetector(
                    onTap: _simulateAddPhoto,
                    child: Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            size: 20, color: AppColors.textDark),
                        const SizedBox(width: 8),
                        const Text('add photo',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textDark)),
                        if (_addedPhotos.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_addedPhotos.length} foto',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Bottom Buttons ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit',
                        style: TextStyle(fontWeight: FontWeight.w700)),
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