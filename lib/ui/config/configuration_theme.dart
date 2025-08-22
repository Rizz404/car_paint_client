import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_car/core/constants/custom_colors.dart';

class ConfigurationTheme {
  const ConfigurationTheme();
  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();

  static const Color _seedColor = CustomColors.guideRed;
  static const Color _primaryColor = CustomColors.guideRed;

  static const Color _lightSurface = CustomColors.pureWhite;
  static const Color _lightBackground = CustomColors.primaryBackground;
  static const Color _lightCardColor = CustomColors.pureWhite;

  static const Color _darkSurface = CustomColors.guideDarkModeGray;
  static const Color _darkBackground = CustomColors.darkPrimaryBackground;
  static const Color _darkCardColor = CustomColors.guideDarkModeGray;

  static ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        primary: _primaryColor,
        onPrimary: CustomColors.pureWhite,
        secondary: CustomColors.guideGray,
        onSecondary: CustomColors.guideDark,
        surface: _lightSurface,
        onSurface: CustomColors.guideDark,
        onSurfaceVariant: CustomColors.guideDarkGray,
        outline: CustomColors.guideGray,
        shadow: const Color(0xFF000000).withAlpha(5),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: ConfigurationTheme.textTheme,
      inputDecorationTheme: ConfigurationTheme.inputDecorationTheme,
      elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
      scaffoldBackgroundColor: CustomColors.guideGray,
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
        foregroundColor: CustomColors.guideDark,
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
        onPrimary: CustomColors.pureWhite,
        secondary: CustomColors.guideDarkGray,
        onSecondary: CustomColors.guideDarkModeDark,
        surface: _darkSurface,
        onSurface: CustomColors.guideDarkModeDark,
        onSurfaceVariant: CustomColors.guideDarkModeDarkGray,
        outline: CustomColors.guideDarkModeDarkGray,
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
        backgroundColor: _darkBackground,
        foregroundColor: CustomColors.guideDarkModeDark,
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
      menuStyle: const MenuStyle(
        elevation: WidgetStatePropertyAll(4),
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  static ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: _seedColor,
      primary: _primaryColor,
      onPrimary: CustomColors.pureWhite,
      surface: _lightSurface,
      secondary: CustomColors.guideGray,
    );
  }

  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: CustomColors.guideDarkGray,
      ),
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: CustomColors.guideDarkGray,
      ),
      contentPadding: const EdgeInsets.all(16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: CustomColors.guideRed,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorMaxLines: 2,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: CustomColors.guideRed,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CustomColors.guideRed,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: CustomColors.guideGray,
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
      hintStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: CustomColors.guideDarkModeDarkGray,
      ),
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: CustomColors.guideDarkModeDarkGray,
      ),
      contentPadding: const EdgeInsets.all(16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: CustomColors.guideRed,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorMaxLines: 2,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: CustomColors.guideRed,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CustomColors.guideRed,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: CustomColors.guideDarkModeDarkGray,
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
      displayLarge: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.poppins(
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
