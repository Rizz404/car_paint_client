import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/local/theme_sp.dart';
import 'package:paint_car/features/shared/cubit/theme_state.dart';
import 'package:paint_car/ui/config/configuration_theme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const Color _primaryColor = Color(0xFF2291FF);
  static const Color _seedColor = Color(0xFF2291FF);
  final ThemeLocal _themeLocal;

  ThemeCubit(this._themeLocal)
      : super(
          ThemeState(
            status: ThemeStatus.light,
            themeData: _buildLightTheme(),
          ),
        );

  void initializeTheme() {
    final isDark = _themeLocal.isDarkMode();
    if (isDark) {
      emit(
        ThemeState(
          status: ThemeStatus.dark,
          themeData: _buildDarkTheme(),
        ),
      );
    } else {
      emit(
        ThemeState(
          status: ThemeStatus.light,
          themeData: _buildLightTheme(),
        ),
      );
    }
  }

  Future<void> toggleTheme() async {
    final isDark = state.status == ThemeStatus.dark;
    await _themeLocal.setDarkMode(!isDark);

    if (isDark) {
      emit(
        ThemeState(
          status: ThemeStatus.light,
          themeData: _buildLightTheme(),
        ),
      );
    } else {
      emit(
        ThemeState(
          status: ThemeStatus.dark,
          themeData: _buildDarkTheme(),
        ),
      );
    }
  }

  Future<void> setTheme(ThemeStatus theme) async {
    await _themeLocal.setDarkMode(theme == ThemeStatus.dark);

    emit(
      ThemeState(
        status: theme,
        themeData:
            theme == ThemeStatus.dark ? _buildDarkTheme() : _buildLightTheme(),
      ),
    );
  }

  static ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        primary: _primaryColor,
        onPrimary: const Color(0xFFFFFFFF),
        surface: const Color(0xFFFFFFFF),
        secondary: const Color(0xFFF2F2F2), // Perbaikan format
        surfaceDim: const Color(0xFF4A4A4A),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: ConfigurationTheme.textTheme,
      inputDecorationTheme: ConfigurationTheme.inputDecorationTheme,
      elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardTheme: const CardThemeData(
        color: Color(0xFFF8F8F8),
        elevation: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        primary: _primaryColor, // Sama dengan light mode
        onPrimary: const Color(0xFFFFFFFF),
        surface: const Color(0xFF1E1E1E),
        secondary: const Color(0xFF2A2A2A),
        surfaceDim: const Color(0xFF121212),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: ConfigurationTheme.textTheme,
      inputDecorationTheme: _buildDarkInputDecorationTheme(),
      elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(
        color: Color(0xFF2A2A2A),
        elevation: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E1E1E),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF1E1E1E),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1E1E1E),
      ),
    );
  }

  static InputDecorationTheme _buildDarkInputDecorationTheme() {
    return InputDecorationTheme(
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF9E9E9E),
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF9E9E9E),
        decorationColor: Color(0xFF9E9E9E),
      ),
      contentPadding: const EdgeInsets.all(16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorMaxLines: 1,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFF424242),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFF424242),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
