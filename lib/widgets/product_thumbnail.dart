import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProductThumbnail extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductThumbnail({
    super.key,
    required this.imageUrl,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.darkTeal : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? AppShadows.card : null,
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.chair,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}