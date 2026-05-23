// lib/screens/home_screen.dart
//
// FIX navigasi navbar:
//  - Pakai IndexedStack agar tidak ada push/pop → tidak ada halaman duplikat
//  - CartScreen, ChatListScreen, ProfileScreen menjadi "tab" bukan "route baru"
//  - Badge keranjang tetap realtime karena CartProvider ada di root (main.dart)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_field.dart';
import '../widgets/promo_banner.dart';
import '../widgets/category_circle.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';          // CartProvider + CartScreen
import 'chat_list_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';       // buat file ini jika belum ada (lihat bawah)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── State navbar ──────────────────────────────────────────────
  int _navIndex = 0;

  // ── State halaman home ────────────────────────────────────────
  int    _selectedCat    = 0;
  String _selectedFilter = 'Semua';
  int _hours = 0, _minutes = 12, _seconds = 59;

  late final AnimationController _headerCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _headerFade =
      Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
  late final Animation<Offset> _headerSlide =
      Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));

  static const List<String> _filters = ['Semua', 'Terbaru', 'Populer'];

  @override
  void initState() {
    super.initState();
    _headerCtrl.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        } else if (_hours > 0) {
          _hours--;
          _minutes = 59;
          _seconds = 59;
        }
      });
      return mounted;
    });
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  // ── Navigasi ke detail produk (tetap push biasa) ──────────────
  void _goToDetail(ProductModel product, String prefix) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) =>
            ProductDetailScreen(product: product, heroTagPrefix: prefix),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _goToAllCategories() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const CategoryScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // ── Handler navbar — IndexedStack, tidak ada push/pop ─────────
  // Tidak ada Navigator.push di sini → tidak ada double-halaman
  void _onNavTap(int index) {
    setState(() => _navIndex = index);
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // ── IndexedStack: semua tab sudah "ada", tinggal tampil ──
      body: SafeArea(
        child: Stack(
          children: [
            // Tab content — tidak di-push, hanya ditampilkan/disembunyikan
            IndexedStack(
              index: _navIndex,
              children: [
                // Tab 0 — Home
                _HomeTab(
                  headerFade: _headerFade,
                  headerSlide: _headerSlide,
                  selectedCat: _selectedCat,
                  selectedFilter: _selectedFilter,
                  filters: _filters,
                  hours: _hours,
                  minutes: _minutes,
                  seconds: _seconds,
                  twoDigits: _twoDigits,
                  onCatSelect: (i) => setState(() => _selectedCat = i),
                  onFilterSelect: (f) =>
                      setState(() => _selectedFilter = f),
                  onProductTap: (p, prefix) => _goToDetail(p, prefix),
                  onAllCategories: _goToAllCategories,
                  onNotifTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                ),

                // Tab 1 — Keranjang
                CartScreen(onBack: () => _onNavTap(0)),

                // Tab 2 — Chat
                ChatListScreen(onBack: () => _onNavTap(0)),

                // Tab 3 — Profil
                ProfileScreen(onBack: () => _onNavTap(0)),
              ],
            ),

            // Floating Bottom Navbar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(
                currentIndex: _navIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME TAB  (konten halaman utama dipindah ke sini)
// ─────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final Animation<double> headerFade;
  final Animation<Offset> headerSlide;
  final int selectedCat;
  final String selectedFilter;
  final List<String> filters;
  final int hours, minutes, seconds;
  final String Function(int) twoDigits;
  final ValueChanged<int> onCatSelect;
  final ValueChanged<String> onFilterSelect;
  final void Function(ProductModel, String) onProductTap;
  final VoidCallback onAllCategories;
  final VoidCallback onNotifTap;

  const _HomeTab({
    required this.headerFade,
    required this.headerSlide,
    required this.selectedCat,
    required this.selectedFilter,
    required this.filters,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.twoDigits,
    required this.onCatSelect,
    required this.onFilterSelect,
    required this.onProductTap,
    required this.onAllCategories,
    required this.onNotifTap,
  });

  @override
  Widget build(BuildContext context) {
    // Terapkan filter kategori dan tab
    final categoryName = AppData.categories[selectedCat].name;
    var displayedProducts = AppData.flashSaleProducts
        .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
        .toList();

    if (selectedFilter == 'Populer') {
      displayedProducts.sort((a, b) => b.raw.sold.compareTo(a.raw.sold));
    } else if (selectedFilter == 'Terbaru') {
      displayedProducts.sort((a, b) => b.raw.id.compareTo(a.raw.id));
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: headerFade,
            child: SlideTransition(
              position: headerSlide,
              child: _buildHeader(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            child: FadeTransition(
              opacity: headerFade,
              child: const SearchField(),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: PromoBanner(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _buildCategorySection(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _buildFlashSaleHeader(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            child: _buildFilterChips(),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 262,
            child: displayedProducts.isEmpty 
              ? const Center(child: Text('Tidak ada produk'))
              : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: displayedProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final p = displayedProducts[i];
                return ProductCard(
                  product: p,
                  animationIndex: i,
                  heroTagPrefix: 'flash_',
                  onTap: () => onProductTap(p, 'flash_'),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: Text('Rekomendasi Untukmu',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Gunakan seluruh produk untuk grid ini
                final p = AppData.flashSaleProducts[index];
                return ProductCard(
                  product: p,
                  animationIndex: index,
                  heroTagPrefix: 'rekomendasi_',
                  onTap: () => onProductTap(p, 'rekomendasi_'),
                );
              },
              childCount: AppData.flashSaleProducts.length,
            ),
          ),
        ),
        // Spacer bawah agar konten tidak tertutup navbar
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lokasi',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 15, color: AppColors.darkTeal),
                    const SizedBox(width: 3),
                    Text('Indonesia, Malang',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(width: 3),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: AppColors.textPrimary),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNotifTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.softGray,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_outlined,
                      size: 20, color: AppColors.textPrimary),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.badge,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kategori',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            GestureDetector(
              onTap: onAllCategories,
              child: Text('Lihat Semua',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTeal)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            AppData.categories.length,
            (i) => CategoryItem(
              category: AppData.categories[i],
              isSelected: selectedCat == i,
              onTap: () => onCatSelect(i),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlashSaleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Flash Sale',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.softGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.timer_outlined,
                  size: 13, color: AppColors.badge),
              const SizedBox(width: 4),
              Text(
                'Berakhir: ${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: filters.map((f) {
        final active = selectedFilter == f;
        return GestureDetector(
          onTap: () => onFilterSelect(f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.darkTeal
                  : AppColors.softGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(f,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active
                        ? Colors.white
                        : AppColors.textSecondary)),
          ),
        );
      }).toList(),
    );
  }
}