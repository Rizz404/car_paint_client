import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocal {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeLocal(this._prefs);

  bool isDarkMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }

  Future<bool> setDarkMode(bool isDark) {
    return _prefs.setBool(_themeKey, isDark);
  }

  Future<bool> removeTheme() => _prefs.remove(_themeKey);
}
