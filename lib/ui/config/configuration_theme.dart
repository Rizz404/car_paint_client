import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_car/core/constants/custom_colors.dart';

class ConfigurationTheme {
  const ConfigurationTheme();
  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();

  static const Color _seedColor = Color(0xFF2291FF);
  static const Color _primaryColor = Color(0xFF2291FF);

  static const Color _lightSurface = Color(0xFFFAFAFA);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFFF5F5F5);
  static const Color _lightCardColor = Color(0xFFFFFFFF);
  static const Color _lightSurfaceDim = Color(0xFFE5E5E5);

  static const Color _darkSurface = Color(0xFF1A1A1A);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSecondary = Color(0xFF2D2D2D);
  static const Color _darkCardColor = Color(0xFF1E1E1E);
  static const Color _darkSurfaceDim = Color(0xFF0F0F0F);

  static ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        primary: _primaryColor,
        onPrimary: const Color(0xFFFFFFFF),
        secondary: const Color(0xFF6B7280),
        onSecondary: const Color(0xFFFFFFFF),
        surface: _lightSurface,
        onSurface: const Color(0xFF1F2937),
        onSurfaceVariant: const Color(0xFF4B5563),
        outline: const Color(0xFFD1D5DB),
        shadow: const Color(0xFF000000).withAlpha(5),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: ConfigurationTheme.textTheme,
      inputDecorationTheme: ConfigurationTheme.inputDecorationTheme,
      elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
      scaffoldBackgroundColor: _lightBackground,
      cardTheme: const CardThemeData(
        color: _lightCardColor,
        elevation: 2,
        shadowColor: Color(0x0F000000),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _lightBackground,
        modalBackgroundColor: _lightBackground,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: _lightBackground,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _lightBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: Color(0xFF1F2937),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
        primary: _primaryColor,
        onPrimary: const Color(0xFFFFFFFF),
        secondary: const Color(0xFF9CA3AF),
        onSecondary: const Color(0xFF1F2937),
        surface: _darkSurface,
        onSurface: const Color(0xFFE5E7EB),
        onSurfaceVariant: const Color(0xFF9CA3AF),
        outline: const Color(0xFF374151),
        shadow: const Color(0xFF000000).withValues(alpha: 0.3),
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: ConfigurationTheme.textTheme,
      inputDecorationTheme: ConfigurationTheme.darkInputDecorationTheme,
      elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
      scaffoldBackgroundColor: _darkBackground,
      cardTheme: const CardThemeData(
        color: _darkCardColor,
        elevation: 4,
        shadowColor: Color(0x30000000),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        modalBackgroundColor: _darkSurface,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: Color(0xFFE5E7EB),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static AppBarTheme appBarTheme(BuildContext context) {
    return AppBarTheme(
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    );
  }

  static DropdownMenuThemeData dropdownMenuTheme(BuildContext context) {
    return DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surfaceVariant,
        ),
        elevation: const WidgetStatePropertyAll(4),
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  static ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: _seedColor,
      primary: _primaryColor,
      onPrimary: const Color(0xFFFFFFFF),
      surface: _lightSurface,
      secondary: _lightSecondary,
      surfaceVariant: _lightSurfaceDim,
    );
  }

  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B7280),
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B7280),
      ),
      contentPadding: const EdgeInsets.all(16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFFEF4444),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorMaxLines: 2,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: Color(0xFFEF4444),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFEF4444),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: _primaryColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static InputDecorationTheme get darkInputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF9CA3AF),
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF9CA3AF),
      ),
      contentPadding: const EdgeInsets.all(16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFFEF4444),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorMaxLines: 2,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: Color(0xFFEF4444),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFEF4444),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFF374151),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: _primaryColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodyLarge: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodySmall: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      labelLarge: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelMedium: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: const TextStyle(
        fontFamily: "Cera Pro",
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
    );
  }
}
