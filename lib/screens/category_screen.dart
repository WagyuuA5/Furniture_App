// lib/screens/category_screen.dart
//
// CategoryScreen – Menampilkan semua 12 kategori dalam grid 4 kolom.
// Navigasi: tombol back → kembali ke HomeScreen.
// FIX: Rename CategoryItem → CategoryData untuk menghindari bentrok
//      dengan widget CategoryItem di category_circle.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

// ─── Model lokal (tidak bentrok dengan CategoryItem di category_circle.dart) ─
class CategoryData {
  final String name;
  final IconData icon;
  const CategoryData({required this.name, required this.icon});
}

// ─── Data 12 kategori ────────────────────────────────────────────────────────
const List<CategoryData> allCategories = [
  CategoryData(name: 'Sofa',         icon: Icons.weekend_rounded),
  CategoryData(name: 'Kursi',        icon: Icons.chair_rounded),
  CategoryData(name: 'Lampu',        icon: Icons.light_rounded),
  CategoryData(name: 'Lemari',       icon: Icons.door_sliding_rounded),
  CategoryData(name: 'Kasur',        icon: Icons.bed_rounded),
  CategoryData(name: 'Meja',         icon: Icons.table_restaurant_rounded),
  CategoryData(name: 'Dapur',        icon: Icons.kitchen_rounded),
  CategoryData(name: 'Kaca',         icon: Icons.crop_portrait_rounded),
  CategoryData(name: 'Stool',        icon: Icons.chair_alt_rounded),
  CategoryData(name: 'Vas',          icon: Icons.local_florist_rounded),
  CategoryData(name: 'Office Chair', icon: Icons.desk_rounded),
  CategoryData(name: 'Other',        icon: Icons.more_horiz_rounded),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGray,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.softGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      title: Text(
        'Kategori',
        style: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.softGray),
      ),
    );
  }

  // ── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: allCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return _CategoryCard(item: allCategories[index]);
        },
      ),
    );
  }
}

// ─── Category Card ────────────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final CategoryData item;
  const _CategoryCard({required this.item});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.88).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
  );

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kategori: ${widget.item.name}'),
            duration: const Duration(milliseconds: 700),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Lingkaran ikon ───────────────────────────────────────────
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.item.icon,
                size: 26,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // ── Label ────────────────────────────────────────────────────
            Text(
              widget.item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}