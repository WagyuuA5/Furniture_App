import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════
//  1. DATA MODEL
// ══════════════════════════════════════════════
class OnboardingData {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

// ══════════════════════════════════════════════
//  2. COLOR PALETTE & TYPOGRAPHY
// ══════════════════════════════════════════════
class AppColors {
  static const teal = Color(0xFF3E5F5A);
  static const tealLight = Color(0xFF547A74);
  static const tealSurface = Color(0xFFEAF2F1);
  static const white = Color(0xFFF8F8F8);
  static const cardWhite = Color(0xFFFFFFFF);
  static const lightGray = Color(0xFFEDEDED);
  static const mediumGray = Color(0xFFB8B8B8);
  static const textDark = Color(0xFF2D2D2D);
  static const textMuted = Color(0xFF7A7A7A);
  static const accent = Color(0xFFD4A853);
  static const shadow = Color(0x14000000);
}

TextStyle _h1() => const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.textDark,
      height: 1.3,
    );

TextStyle _body() => const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
      height: 1.6,
    );

TextStyle _label({Color color = AppColors.textDark, double size = 12}) =>
    TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
    );

// ══════════════════════════════════════════════
//  3. ONBOARDING SCREEN
// ══════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;

  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  static const int _totalPages = 3;

  // ✅ PERBAIKAN PATH GAMBAR (tanpa "assets/")
  static const List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Pengalaman Belanja yang\nLancar dan Nyaman',
      subtitle: 'Nikmati pengalaman belanja yang mudah,\ncepat, dan nyaman kapan saja.',
      imagePath: 'images/onboarding_1.png',  // ✅ BENAR
    ),
    OnboardingData(
      title: 'Lacak Pesananmu\nSecara Real-Time',
      subtitle: 'Pantau status pengiriman furniture\nfavoritmu dengan mudah dan akurat.',
      imagePath: 'images/onboarding_2.png',  // ✅ BENAR
    ),
    OnboardingData(
      title: 'Simpan Favorit &\nBelanja Kapan Saja',
      subtitle: 'Tambahkan produk ke wishlist dan\ntemukan penawaran terbaik untukmu.',
      imagePath: 'images/onboarding_3.png',  // ✅ BENAR
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _navigateTo(int page) async {
    await _fadeController.animateTo(0,
        duration: const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _currentPage = page);
    await _fadeController.animateTo(1,
        duration: const Duration(milliseconds: 350));
  }

  void _onNext() {
    if (_currentPage < _totalPages - 1) {
      _navigateTo(_currentPage + 1);
    } else {
      _finish();
    }
  }

  void _onBack() {
    if (_currentPage > 0) _navigateTo(_currentPage - 1);
  }

  // ✅ PERBAIKAN ROUTING - menggunakan Navigator.pushNamed
  void _finish() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal.withOpacity(0.04),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 24),
                    child: TextButton(
                      onPressed: _finish,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Skip',
                          style: _label(color: AppColors.textMuted, size: 14)),
                    ),
                  ),
                ),

                // IMAGE AREA
                Expanded(
                  flex: 6,
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: _OnboardingImage(imagePath: page.imagePath),
                      ),
                    ),
                  ),
                ),

                // TEXT AREA
                Expanded(
                  flex: 3,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            page.title,
                            style: _h1(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page.subtitle,
                            style: _body(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // BOTTOM BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedOpacity(
                        opacity: _currentPage > 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: _CircleButton(
                          onTap: _currentPage > 0 ? _onBack : null,
                          filled: false,
                          child: const Icon(Icons.arrow_back_rounded,
                              color: AppColors.teal, size: 20),
                        ),
                      ),
                      _CustomIndicator(
                        count: _totalPages,
                        current: _currentPage,
                      ),
                      _AnimatedNextButton(
                        isLast: _currentPage == _totalPages - 1,
                        onTap: _onNext,
                      ),
                    ],
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

// ══════════════════════════════════════════════
//  4. IMAGE WIDGET
// ══════════════════════════════════════════════
class _OnboardingImage extends StatelessWidget {
  final String imagePath;
  const _OnboardingImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withOpacity(0.18),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: 300,  // ✅ ukuran gambar diperbesar
          height: 300, // ✅ ukuran gambar diperbesar
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.tealSurface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_search_rounded,
                    color: AppColors.teal,
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gambar tidak ditemukan\n$imagePath',
                    textAlign: TextAlign.center,
                    style: _label(color: AppColors.textMuted, size: 11),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  5. CUSTOM PAGE INDICATOR
// ══════════════════════════════════════════════
class _CustomIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _CustomIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? AppColors.teal : AppColors.mediumGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════
//  6. ANIMATED NEXT BUTTON
// ══════════════════════════════════════════════
class _AnimatedNextButton extends StatefulWidget {
  final bool isLast;
  final VoidCallback onTap;
  const _AnimatedNextButton({required this.isLast, required this.onTap});

  @override
  State<_AnimatedNextButton> createState() => _AnimatedNextButtonState();
}

class _AnimatedNextButtonState extends State<_AnimatedNextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) {
    _controller.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => _controller.forward(),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: widget.isLast
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                : const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  7. CIRCLE BUTTON
// ══════════════════════════════════════════════
class _CircleButton extends StatelessWidget {
  final Widget child;
  final bool filled;
  final VoidCallback? onTap;
  const _CircleButton({required this.child, this.filled = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: filled ? AppColors.teal : AppColors.cardWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: filled
                  ? AppColors.teal.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}