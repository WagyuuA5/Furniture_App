import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Colors ───────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color darkTeal         = Color(0xFF1A5C5A);
  static const Color darkTealLight    = Color(0xFF236E6C);
  static const Color white            = Color(0xFFFFFFFF);
  static const Color softGray         = Color(0xFFF2F3F5);
  static const Color textPrimary      = Color(0xFF1A1D1E);
  static const Color textSecondary    = Color(0xFF8A9099);
  static const Color badge            = Color(0xFFE63946);
  static const Color navbarBg         = Color(0xFF1A1D1E);

  // ── Alias colors used by filter / product-list / rating screens ──
  static const Color primary          = darkTeal;
  static const Color accent           = Color(0xFF2C6E49);
  static const Color chipSelected     = darkTeal;
  static const Color chipUnselected   = Color(0xFFF0EFED);
  static const Color textDark         = Color(0xFF1A1D1E);
  static const Color textGrey         = Color(0xFF8A9099);
  static const Color background       = Color(0xFFFAF9F7);
  static const Color divider          = Color(0xFFEEECE8);

  /// Icon color inside the bottom nav bar (always white, active or not).
  static const Color navbarActiveIcon = Color(0xFFFFFFFF);

  /// Runtime-only helpers (withOpacity → cannot be const).
  static Color get navbarBgLight => navbarBg.withOpacity(0.95);
  static Color get darkTealFaded => darkTeal.withOpacity(0.12);
}

// ── Radii ────────────────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();

  static const double productCard  = 16;
  static const double mainCard     = 20;
  static const double button       = 14;
  static const double searchBar    = 14;
  static const double bottomNavbar = 34;
}

// ── Shadows ──────────────────────────────────────────────────────────────────
// BoxShadow.color uses withOpacity (runtime) → must be getters, not const.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get navbar => [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.18),
          blurRadius: 24,
          offset: const Offset(0, -4),
        ),
      ];

  static List<BoxShadow> get promo => [
        BoxShadow(
          color: AppColors.darkTeal.withOpacity(0.30),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}

// ── Text styles ──────────────────────────────────────────────────────────────
// GoogleFonts calls are runtime → keep as static getters, never const.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get price => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTeal,
      );

  static TextStyle get priceOld => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );
}

// ── App-level ThemeData ───────────────────────────────────────────────────────
/// Used by [MaterialApp.theme] in main.dart:
///   theme: AppTheme.theme,
class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkTeal,
          primary: AppColors.darkTeal,
          surface: AppColors.white,
        ),
        // Apply Poppins globally so widgets that fall back to the theme
        // also get the right font.
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkTeal,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.softGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.searchBar),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );
}