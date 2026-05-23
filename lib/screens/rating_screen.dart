// screens/rating_screen.dart
// Halaman daftar review produk – sesuai desain Gambar 4

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/app_theme.dart';
import '../widgets/rating_widget.dart';
import 'leave_review_screen.dart';

class RatingScreen extends StatefulWidget {
  final ProductModel product;

  const RatingScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  String _sortFilter = 'Terbaru';

  List<Review> get _sortedReviews {
    final reviews = List<Review>.from(widget.product.reviews);
    if (_sortFilter == 'Terbaru') {
      return reviews; // Assume already sorted by newest
    } else if (_sortFilter == 'Terlama') {
      return reviews.reversed.toList();
    }
    return reviews;
  }

  // Build bar chart data
  Map<int, int> get _starCounts {
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in widget.product.reviews) {
      final star = r.rating.round().clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }
    return counts;
  }

  int get _maxStarCount {
    return _starCounts.values.fold(0, (a, b) => a > b ? a : b);
  }

  void _goToLeaveReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveReviewScreen(product: widget.product),
      ),
    );
    if (result == true) setState(() {});
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
        title: const Text('Review'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Rating Summary ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Big rating number
                      Column(
                        children: [
                          Text(
                            widget.product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '(${widget.product.reviewCount} Reviews)',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Bar chart
                      Expanded(
                        child: Column(
                          children: [5, 4, 3, 2, 1].map((star) {
                            final count = _starCounts[star] ?? 0;
                            final maxCount =
                                _maxStarCount == 0 ? 1 : _maxStarCount;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    '$star',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textGrey),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: count / maxCount,
                                        minHeight: 6,
                                        backgroundColor: AppColors.chipUnselected,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                AppColors.primary),
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
                ),

                const Divider(height: 1, color: AppColors.divider),

                // ─── Sort Filter ─────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      // Filter icon button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.tune, size: 16),
                            SizedBox(width: 4),
                            Text('Filter',
                                style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _sortChip('Terbaru'),
                      const SizedBox(width: 8),
                      _sortChip('Terlama'),
                    ],
                  ),
                ),

                // ─── Review List ─────────────────────────────────────────
                if (_sortedReviews.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Belum ada review.\nJadi yang pertama!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ),
                  )
                else
                  ..._sortedReviews.map((review) => _buildReviewCard(review)),
              ],
            ),
          ),

          // ─── Floating Bottom Button ──────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ElevatedButton(
                onPressed: _goToLeaveReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Tulis Komentar',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(String label) {
    final selected = _sortFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _sortFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.chipUnselected,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          StarDisplayWidget(rating: review.rating, size: 14),
        ],
      ),
    );
  }
}