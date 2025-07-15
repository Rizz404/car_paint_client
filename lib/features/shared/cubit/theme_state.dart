import 'package:flutter/material.dart';

enum ThemeStatus { light, dark }

class ThemeState {
  final ThemeStatus status;
  final ThemeData themeData;

  const ThemeState({
    required this.status,
    required this.themeData,
  });

  ThemeState copyWith({
    ThemeStatus? status,
    ThemeData? themeData,
  }) {
    return ThemeState(
      status: status ?? this.status,
      themeData: themeData ?? this.themeData,
    );
  }
}
