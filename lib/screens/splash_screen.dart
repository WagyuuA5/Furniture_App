import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Stage: 0=roundedSquare, 1=diamond, 2=dot, 3=textOnly, 4=logoWithText
  int _stage = 0;

  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late AnimationController _shrinkController;

  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _shrinkAnim;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shrinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotateAnim = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
    _shrinkAnim = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _shrinkController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Stage 0: rounded square appears
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // Stage 1: rotate to diamond
    setState(() => _stage = 1);
    _rotateController.forward();
    await Future.delayed(const Duration(milliseconds: 700));

    // Stage 2: shrink to dot
    setState(() => _stage = 2);
    _shrinkController.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    // Stage 3: text only "Luxe Furnish"
    setState(() => _stage = 3);
    _shrinkController.reset();
    _scaleController.reset();
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 900));

    // Stage 4: logo circle + text
    setState(() => _stage = 4);
    _scaleController.reset();
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));

    // Navigate to onboarding
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _fadeController.dispose();
    _shrinkController.dispose();
    super.dispose();
  }

  static const Color _primary = Color(0xFF2E6B6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _buildStage(),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case 0:
        return AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A8F8F), Color(0xFF1A4A4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        );

      case 1:
        return AnimatedBuilder(
          animation: _rotateAnim,
          builder: (_, __) => Transform.rotate(
            angle: _rotateAnim.value * 2 * 3.14159,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A8F8F), Color(0xFF1A4A4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        );

      case 2:
        return AnimatedBuilder(
          animation: _shrinkAnim,
          builder: (_, __) {
            final size = 110.0 * _shrinkAnim.value;
            return Container(
              width: size.clamp(10.0, 110.0),
              height: size.clamp(10.0, 110.0),
              decoration: BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
              ),
            );
          },
        );

      case 3:
        return AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnim.value,
            child: Text(
              'Luxe\nFurnish',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
                height: 1.15,
                letterSpacing: -0.5,
              ),
            ),
          ),
        );

      case 4:
      default:
        return AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnim.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A8F8F), Color(0xFF1A4A4A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chair_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Luxe',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        height: 1.0,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Furnish',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E6B6B),
                        height: 1.0,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }
}