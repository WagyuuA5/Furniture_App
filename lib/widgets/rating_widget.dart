import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. RatingWidget — display-only stars with rating number (used in detail, card)
// ─────────────────────────────────────────────────────────────────────────────

class RatingWidget extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;

  /// Interactive mode: jika onRatingChanged != null, bintang bisa di-tap
  final int? initialRating;
  final double? size;
  final ValueChanged<int>? onRatingChanged;

  const RatingWidget({
    super.key,
    this.rating = 0,
    this.reviewCount,
    this.starSize = 16,
    this.initialRating,
    this.size,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Kalau interactive mode (onRatingChanged != null), gunakan builder interaktif
    if (onRatingChanged != null) {
      return _InteractiveStars(
        currentRating: initialRating ?? 0,
        size: size ?? starSize,
        onRatingChanged: onRatingChanged!,
      );
    }

    final displaySize = size ?? starSize;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = index < rating.floor();
          final half = !filled && index < rating;
          return Icon(
            half ? Icons.star_half_rounded : Icons.star_rounded,
            size: displaySize,
            color: filled || half
                ? const Color(0xFFFFC107)
                : AppColors.softGray,
          );
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.poppins(
            fontSize: displaySize * 0.8,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount ulasan)',
            style: GoogleFonts.poppins(
              fontSize: displaySize * 0.75,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. _InteractiveStars — internal widget for tap-to-rate
// ─────────────────────────────────────────────────────────────────────────────

class _InteractiveStars extends StatelessWidget {
  final int currentRating;
  final double size;
  final ValueChanged<int> onRatingChanged;

  const _InteractiveStars({
    required this.currentRating,
    required this.size,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: starIndex <= currentRating
                  ? const Color(0xFFFFC107)
                  : AppColors.softGray,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. StarDisplayWidget — simple display-only stars (used by filter, rating screen)
// ─────────────────────────────────────────────────────────────────────────────

class StarDisplayWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool showNumber;

  const StarDisplayWidget({
    super.key,
    required this.rating,
    this.size = 16,
    this.showNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = index < rating.floor();
          final half = !filled && index < rating;
          return Icon(
            half ? Icons.star_half_rounded : Icons.star_rounded,
            size: size,
            color: filled || half
                ? const Color(0xFFFFC107)
                : AppColors.softGray,
          );
        }),
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              fontSize: size * 0.75,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. getRatingLabel — label text for each star rating
// ─────────────────────────────────────────────────────────────────────────────

String getRatingLabel(int rating) {
  switch (rating) {
    case 1:
      return 'Sangat Buruk 😞';
    case 2:
      return 'Buruk 😕';
    case 3:
      return 'Cukup 😐';
    case 4:
      return 'Bagus 😊';
    case 5:
      return 'Sangat Bagus! 🤩';
    default:
      return '';
  }
}