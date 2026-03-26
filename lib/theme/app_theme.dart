import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.plumDark,
        secondary: AppColors.coral,
        surface: AppColors.card,
        error: AppColors.destructive,
        onPrimary: AppColors.cream,
        onSecondary: AppColors.foreground,
        onSurface: AppColors.foreground,
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      dividerColor: AppColors.border,
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.card,
        selectedColor: AppColors.plumDark,
        secondarySelectedColor: AppColors.plumDark,
        labelStyle: const TextStyle(
          color: AppColors.foreground,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.cream,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(22),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(22),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.plumDark, width: 1.4),
          borderRadius: BorderRadius.circular(22),
        ),
        hintStyle: const TextStyle(
          color: AppColors.mutedForeground,
          fontSize: 14,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.plumDark,
        contentTextStyle: const TextStyle(color: AppColors.cream),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: 'Playfair Display',
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: 'Poppins',
        color: AppColors.foreground,
        height: 1.45,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: 'Poppins',
        color: AppColors.foreground,
        height: 1.45,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: 'Poppins',
        color: AppColors.mutedForeground,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
