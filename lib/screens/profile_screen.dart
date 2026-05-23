// lib/screens/profile_screen.dart
// PERUBAHAN: Import PrivacyPolicyScreen + ganti onTap 'Kebijakan Privasi' dari SnackBar ke navigasi halaman

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import 'manage_address_screen.dart';
import 'manage_payment_methods_screen.dart';
import 'my_orders_screen.dart';
import 'my_coupons_screen.dart';
import 'settings_screen.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart'; // ← TAMBAHKAN BARIS INI
import 'login_screen.dart';

// UPDATE AREA: Ganti model data ini dengan state management (GetX/Provider) jika perlu
class ProfileData {
  static String name = 'Esther Howard';
  static String email = 'esther.howard@email.com';
  static String phone = '+62 812-3456-7890';
  static String? photoPath; // null = gunakan placeholder
}

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _primary = Color(0xFF2D6A6A);
  static const Color _bg = Color(0xFFFAFAF8);

  // UPDATE AREA: Daftar menu profil
  late final List<_MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = [
      _MenuItem(
        icon: Icons.person_outline_rounded,
        label: 'Profil Anda',
        onTap: () async {
          await Navigator.push(
            context,
            _slide(const EditProfileScreen()),
          );
          setState(() {}); // refresh nama setelah edit
        },
      ),
      _MenuItem(
        icon: Icons.location_on_outlined,
        label: 'Alamat Saya',
        onTap: () => Navigator.push(context, _slide(const ManageAddressScreen())),
      ),
      _MenuItem(
        icon: Icons.credit_card_outlined,
        label: 'Metode Pembayaran',
        onTap: () => Navigator.push(context, _slide(const ManagePaymentMethodsScreen())),
      ),
      _MenuItem(
        icon: Icons.receipt_long_outlined,
        label: 'Pesanan Saya',
        onTap: () => Navigator.push(context, _slide(const MyOrdersScreen())),
      ),
      _MenuItem(
        icon: Icons.discount_outlined,
        label: 'Kupon Saya',
        onTap: () => Navigator.push(context, _slide(const MyCouponsScreen())),
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        label: 'Pengaturan',
        onTap: () => Navigator.push(context, _slide(const SettingsScreen())),
      ),
      _MenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Pusat Bantuan',
        onTap: () => Navigator.push(context, _slide(const HelpCenterScreen())),
      ),
      _MenuItem(
        icon: Icons.lock_outline_rounded,
        label: 'Kebijakan Privasi',
        // ↓ UBAH BAGIAN INI: dari SnackBar 'coming soon' jadi navigasi ke halaman
        onTap: () => Navigator.push(context, _slide(const PrivacyPolicyScreen())),
      ),
    ];
  }

  PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, anim, __) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Keluar',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Apakah Anda yakin ingin keluar?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2D6A6A)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.poppins(
                        color: _primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      // UPDATE AREA: Tambahkan logika logout di sini
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Ya, Keluar',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.onBack != null) widget.onBack!();
                      else Navigator.maybePop(context);
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Profil',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 28),

                  // ── Avatar ──
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: ProfileData.photoPath != null
                                ? DecorationImage(
                                    image:
                                        AssetImage(ProfileData.photoPath!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: ProfileData.photoPath == null
                              ? const Icon(Icons.person,
                                  size: 46, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                _slide(const EditProfileScreen()),
                              );
                              setState(() {});
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Nama ──
                  Center(
                    child: Text(
                      ProfileData.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Menu Items ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(_menuItems.length, (i) {
                        final item = _menuItems[i];
                        final isLast = i == _menuItems.length - 1;
                        return Column(
                          children: [
                            InkWell(
                              onTap: item.onTap,
                              borderRadius: BorderRadius.vertical(
                                top: i == 0
                                    ? const Radius.circular(16)
                                    : Radius.zero,
                                bottom: isLast
                                    ? const Radius.circular(16)
                                    : Radius.zero,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 16),
                                child: Row(
                                  children: [
                                    Icon(item.icon,
                                        size: 22,
                                        color: const Color(0xFF555555)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Color(0xFF9E9E9E)),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              Divider(
                                  height: 1,
                                  indent: 56,
                                  color: Colors.grey[100]),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Tombol Keluar ──
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout_rounded,
                          color: Color(0xFFE53935), size: 20),
                      label: Text(
                        'Keluar',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE53935),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE53935)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});
}