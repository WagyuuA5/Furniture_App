import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// PROMO BANNER WIDGET - FULLY FIXED
// No animation controller issues, no overflow
// ============================================================

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  int _currentIndex = 0;
  
  // Data promo dengan gambar Anda
  final List<PromoData> _promos = [
    PromoData(
      title: 'Upgrade Ruanganmu\nHari Ini',
      subtitle: 'Koleksi sofa premium dengan desain modern dan harga spesial.',
      discount: 'Diskon 25%',
      imagePath: 'assets/images/diskon_1.png',
      buttonText: 'Lihat Koleksi',
    ),
    PromoData(
      title: 'Simple Design,\nMaximum Comfort',
      subtitle: 'Minimalis, modern, dan dibuat untuk kenyamanan sehari-hari.',
      discount: 'Diskon 20%',
      imagePath: 'assets/images/diskon_2.png',
      buttonText: 'Lihat Koleksi',
    ),
    PromoData(
      title: 'Diskon Hingga\n30%',
      subtitle: 'Koleksi sofa & kursi pilihan dengan kualitas terbaik.',
      discount: 'Diskon 30%',
      imagePath: 'assets/images/diskon_3.png',
      buttonText: 'Belanja Sekarang',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _nextSlide();
      }
    });
  }

  void _nextSlide() {
    if (!mounted) return;
    
    int nextIndex = (_currentIndex + 1) % _promos.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel Slider
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              return _PromoCard(
                promo: _promos[index],
                isActive: _currentIndex == index,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentIndex == index
                    ? const Color(0xFF2E6B6B)
                    : const Color(0xFF2E6B6B).withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ============================================================
// PROMO DATA MODEL
// ============================================================
class PromoData {
  final String title;
  final String subtitle;
  final String discount;
  final String imagePath;
  final String buttonText;

  PromoData({
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.imagePath,
    required this.buttonText,
  });
}

// ============================================================
// PROMO CARD WIDGET
// ============================================================
class _PromoCard extends StatelessWidget {
  final PromoData promo;
  final bool isActive;

  const _PromoCard({
    required this.promo,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      transform: Matrix4.identity()..scale(isActive ? 1.0 : 0.97),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2E6B6B),
              Color(0xFF1A4A4A),
              Color(0xFF3E5F5A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E6B6B).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT SIDE - TEXT CONTENT
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Discount Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promo.discount,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Title
                    Text(
                      promo.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // Subtitle
                    Text(
                      promo.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    
                    // Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            promo.buttonText,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E6B6B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 11,
                            color: const Color(0xFF2E6B6B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // RIGHT SIDE - IMAGE
              Expanded(
                flex: 4,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      promo.imagePath,
                      fit: BoxFit.contain,
                      height: 110,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.weekend_rounded,
                            size: 50,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}