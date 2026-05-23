import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../models/product.dart';

class CategoryItem extends StatefulWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.86).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'sofa':     return Icons.weekend_rounded;
      case 'chair':    return Icons.chair_rounded;
      case 'lamp':     return Icons.light_rounded;
      case 'wardrobe': return Icons.door_sliding_rounded;
      default:         return Icons.category_rounded;
    }
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
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.darkTeal.withOpacity(0.12)
                    : AppColors.softGray,
                shape: BoxShape.circle,
                border: widget.isSelected
                    ? Border.all(color: AppColors.darkTeal, width: 1.5)
                    : Border.all(color: Colors.transparent, width: 1.5),
              ),
              child: Center(
                child: Icon(
                  _iconFor(widget.category.icon),
                  size: 26,
                  color: widget.isSelected
                      ? AppColors.darkTeal
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.category.name,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                color: widget.isSelected
                    ? AppColors.darkTeal
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}