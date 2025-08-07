import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/local/theme_sp.dart';
import 'package:paint_car/features/shared/cubit/theme_state.dart';
import 'package:paint_car/ui/config/configuration_theme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeLocal _themeLocal;

  ThemeCubit(this._themeLocal)
      : super(
          ThemeState(
            status: ThemeStatus.dark,
            themeData: ConfigurationTheme.darkTheme,
          ),
        );

  void initializeTheme() {
    final isDark = _themeLocal.isDarkMode();
    if (isDark) {
      emit(
        ThemeState(
          status: ThemeStatus.dark,
          themeData: ConfigurationTheme.darkTheme,
        ),
      );
    } else {
      emit(
        ThemeState(
          status: ThemeStatus.light,
          themeData: ConfigurationTheme.lightTheme,
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
          themeData: ConfigurationTheme.lightTheme,
        ),
      );
    } else {
      emit(
        ThemeState(
          status: ThemeStatus.dark,
          themeData: ConfigurationTheme.darkTheme,
        ),
      );
    }
  }

  Future<void> setTheme(ThemeStatus theme) async {
    await _themeLocal.setDarkMode(theme == ThemeStatus.dark);
    emit(
      ThemeState(
        status: theme,
        themeData: theme == ThemeStatus.dark
            ? ConfigurationTheme.darkTheme
            : ConfigurationTheme.lightTheme,
      ),
    );
  }
}
