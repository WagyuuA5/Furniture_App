import 'package:flutter/material.dart';
import 'package:my_design_system/my_design_system.dart' as ds;

class AppColors {
  AppColors._();

  static const Color darkTeal = ds.AppColors.primary600;
  static const Color darkTealLight = ds.AppColors.primary400;
  static const Color white = ds.AppColors.surfaceLight;
  static const Color softGray = ds.AppColors.neutral100;
  static const Color textPrimary = ds.AppColors.neutral900;
  static const Color textSecondary = ds.AppColors.neutral500;
  static const Color badge = ds.AppColors.error;
  static const Color navbarBg = ds.AppColors.neutral900;

  static const Color primary = ds.AppColors.primary;
  static const Color accent = ds.AppColors.secondary;
  static const Color chipSelected = ds.AppColors.primary;
  static const Color chipUnselected = ds.AppColors.neutral200;
  static const Color textDark = ds.AppColors.neutral900;
  static const Color textGrey = ds.AppColors.neutral500;
  static const Color background = ds.AppColors.backgroundLight;
  static const Color divider = ds.AppColors.neutral200;

  static const Color navbarActiveIcon = ds.AppColors.surfaceLight;

  static Color get navbarBgLight => navbarBg.withValues(alpha: 0.95);
  static Color get darkTealFaded => primary.withValues(alpha: 0.12);
}

class AppRadius {
  AppRadius._();
  static const double productCard = ds.AppRadius.xl;
  static const double mainCard = ds.AppRadius.xxl;
  static const double button = ds.AppRadius.md;
  static const double searchBar = ds.AppRadius.lg;
  static const double bottomNavbar = 34;
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get navbar => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.18),
      blurRadius: 24,
      offset: const Offset(0, -4),
    ),
  ];

  static List<BoxShadow> get promo => [
    BoxShadow(
      color: ds.AppColors.primary.withValues(alpha: 0.30),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get price => ds.AppTextStyle.bodyLg.copyWith(
    fontWeight: FontWeight.w700,
    color: ds.AppColors.primary,
  );

  static TextStyle get priceOld => ds.AppTextStyle.bodySm.copyWith(
    color: ds.AppColors.neutral500,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get sectionTitle =>
      ds.AppTextStyle.titleLg.copyWith(color: ds.AppColors.neutral900);
}

class AppTheme {
  AppTheme._();
  static ThemeData get theme => ds.AppTheme.light;
}
