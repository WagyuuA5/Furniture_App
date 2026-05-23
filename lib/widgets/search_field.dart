// lib/widgets/search_field.dart
// UPDATE FINAL:
//  - Tap → push SearchScreen dengan fade transition
//  - Tidak lagi readonly
//  - Hint text konsisten "Cari......"

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../screens/search_screen.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const SearchField({
    super.key,
    this.hintText = 'Cari......',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, anim, __) => const SearchScreen(),
                  transitionsBuilder: (_, anim, __, child) => FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                  transitionDuration: const Duration(milliseconds: 200),
                ),
              ),
      // Agar GestureDetector aktif di seluruh area container
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(AppRadius.searchBar),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hintText,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Mic icon (opsional, sesuai desain)
            const Icon(
              Icons.mic_none_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}