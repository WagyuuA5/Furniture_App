import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme.dart';
import '../screens/home_screen.dart';

// ============================================================
// Login / Register Screen — clean minimal
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscure = true;
  bool _isLoading = false;

  // Text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Untuk register

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _fade =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
  );
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ✅ FUNGSI LOGIN YANG BENAR
  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi email dan password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi proses login (ganti dengan API call Anda)
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    // ✅ Setelah login sukses, pindah ke HomeScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    }
  }

  // ✅ FUNGSI REGISTER YANG BENAR (dari RegisterScreen pindah ke sini)
  void _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi proses register (ganti dengan API call Anda)
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      // ✅ Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      
      // ✅ Kembali ke mode LOGIN (bukan ke HomeScreen)
      setState(() {
        _isLogin = true;
        _isLoading = false;
        // Kosongkan form
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
      });
      
      // Animasi ulang
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo mark
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.darkTeal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.weekend_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 28),

                    // Title
                    Text(
                      _isLogin ? 'Welcome\nBack 👋' : 'Create\nAccount 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D2D2D),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Sign in to continue your Luxe Furnish.'
                          : 'Join us and discover premium furniture.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Name field (register only)
                    if (!_isLogin) ...[
                      _InputField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'John Doe',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email
                    _InputField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _InputField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),
                    ),

                    // Forgot password
                    if (_isLogin) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkTeal,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),

                    // ✅ PRIMARY BUTTON (SUDAH DIPERBAIKI)
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : (_isLogin ? _handleLogin : _handleRegister),
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.darkTeal,
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkTeal.withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'Sign In' : 'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('or',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF7B7B7B))),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Google login
                    _SocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Continue with Google',
                      onTap: _handleLogin, // Sementara pakai login biasa
                    ),
                    const SizedBox(height: 30),

                    // Toggle login/register
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isLogin = !_isLogin;
                          _isLoading = false;
                          _ctrl.reset();
                          _ctrl.forward();
                        }),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF7B7B7B)),
                            children: [
                              TextSpan(
                                  text: _isLogin
                                      ? "Don't have an account? "
                                      : 'Already have an account? '),
                              TextSpan(
                                text: _isLogin ? 'Sign Up' : 'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Reusable Input Field (DIPERBAIKI dengan controller) ----
class _InputField extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D2D2D))),
        const SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF2D2D2D)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFFB0B0B0)),
              prefixIcon:
                  Icon(icon, size: 20, color: const Color(0xFF7B7B7B)),
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: suffix,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ---- Social Button ----
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: const Color(0xFF2D2D2D)),
            const SizedBox(width: 10),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2D2D))),
          ],
        ),
      ),
    );
  }
}