import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../models/product.dart';

// ============================================================
// Product Card Widget — Flash Sale item dengan Hero + animasi
// ============================================================
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final int animationIndex;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _fade =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
  );

  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
  );

  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    // Stagger berdasarkan index
    Future.delayed(
      Duration(milliseconds: widget.animationIndex * 120),
      () { if (mounted) _ctrl.forward(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Format harga Indonesia
  String _formatPrice(double price) {
    if (price >= 1000000) {
      final val = price / 1000000;
      return 'Rp${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)}jt';
    }
    final str = price.toInt().toString();
    final buf = StringBuffer('Rp');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 140),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.productCard),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---- Image + Badge ----
                  Stack(
                    children: [
                      Hero(
                        tag: 'product_${widget.product.id}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft:  Radius.circular(AppRadius.productCard),
                            topRight: Radius.circular(AppRadius.productCard),
                          ),
                          child: SizedBox(
                            height: 140,
                            width: double.infinity,
                            child: Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const ColoredBox(
                                color: AppColors.softGray,
                                child: Center(
                                  child: Icon(Icons.chair_rounded,
                                      size: 48, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.product.discountPercent != null)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.badge,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '${widget.product.discountPercent}% OFF',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // ---- Info ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatPrice(widget.product.price),
                          style: AppTextStyles.price,
                        ),
                        if (widget.product.oldPrice != null)
                          Text(
                            _formatPrice(widget.product.oldPrice!),
                            style: AppTextStyles.priceOld,
                          ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 13, color: Colors.amber),
                            const SizedBox(width: 3),
                            Text(
                              widget.product.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
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
          ),
        ),
      ),
    );
  }
}