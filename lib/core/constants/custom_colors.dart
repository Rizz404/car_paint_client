import 'package:flutter/material.dart';

class CustomColors {
  static const textIcon = Color(0xFF20272F);
  static const border = Color(0xFF79747E);
  static const secondaryBorder = Color(0xFF757575);
  static const white = Color(0xFFFFFFFF);
  static const secondaryWhite = Color(0xFFF8F8F8);
  static const black = Color(0xFF000000);
  static const blue = Color(0xFF007BFF);
  static const red = Color(0xFFAF2828);
  static const secondaryRed = Color(0xffE63B2A);
  static const secondaryBlue = Color(0xFF2291FF);
  static const tertiaryBlue = Color(0xFF1E88E5);
  static const aliceBlue = Color(0xFFF0F5FD);
  static const gray = Color(0xFFD9D9D9);
  static const secondaryGray = Color(0xFF78828A);
  static const tertiaryGray = Color(0xFF616161);
  static const fourthGray = Color(0xFFFEFEFE);
  static const fifthGray = Color(0xD6D6D6D6);

  static const darkTextIcon = Color(0xFFFFFFFF);
  static const darkBorder = Color(0xFF404040);
  static const darkSecondaryBorder = Color(0xFF606060);
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSecondary = Color(0xFF2A2A2A);
  static const darkGray = Color(0xFF404040);
  static const darkSecondaryGray = Color(0xFF606060);
  static const darkTertiaryGray = Color(0xFF808080);

  static const guideRed = Color(0xFFE63B2A);
  static const guideGray = Color(0xFFE6E7E8);
  static const guideDarkGray = Color(0xFF707072);
  static const guideDark = Color(0xFF20272F);

  static const guideDarkModeGray = Color(0xFF2C2C2E);
  static const guideDarkModeDarkGray = Color(0xFF8E8E93);
  static const guideDarkModeDark = Color(0xFFFFFFFF);

  static const pureWhite = Color(0xFFFFFFFF);
  static const pureBlack = Color(0xFF000000);

  static const primaryBackground = Color(0xFFE6E7E8);
  static const primaryCard = Color(0xFFFFFFFF);
  static const primaryText = Color(0xFF20272F);
  static const secondaryText = Color(0xFF707072);
  static const primaryBorder = Color(0xFFE6E7E8);
  static const primaryBorderInput = Color(0xFF79747E);

  static const darkPrimaryBackground = Color(0xFF121212);
  static const darkPrimaryCard = Color(0xFF1E1E1E);
  static const darkPrimaryText = Color(0xFFFFFFFF);
  static const darkSecondaryText = Color(0xFFA0A0A0);
  static const darkPrimaryBorder = Color(0xFF2C2C2E);

  static const bothThemeBottomBorder = Color(0xFF70707233);
}

extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get adaptivePrimaryBackground => isDarkMode
      ? CustomColors.darkPrimaryBackground
      : CustomColors.primaryBackground;

  Color get adaptivePrimaryCard =>
      isDarkMode ? CustomColors.darkPrimaryCard : CustomColors.primaryCard;

  Color get adaptiveTextColor =>
      isDarkMode ? CustomColors.darkPrimaryText : CustomColors.primaryText;

  Color get adaptiveBorderColor =>
      isDarkMode ? CustomColors.guideDarkModeDarkGray : CustomColors.guideGray;

  Color get adaptiveBorderInputColor => isDarkMode
      ? CustomColors.darkPrimaryBorder
      : CustomColors.primaryBorderInput;

  Color get adaptiveBackgroundColor =>
      isDarkMode ? CustomColors.guideDarkModeGray : CustomColors.pureWhite;

  Color get adaptiveCommonColor =>
      isDarkMode ? CustomColors.pureBlack : CustomColors.pureWhite;

  Color get adaptiveSecondaryColor =>
      isDarkMode ? CustomColors.guideDarkModeGray : CustomColors.guideGray;
  Color get adaptiveTertiaryColor =>
      isDarkMode ? CustomColors.guideDarkModeDark : CustomColors.guideDark;
  Color get adaptivePrimaryColor =>
      isDarkMode ? CustomColors.guideDarkGray : CustomColors.guideGray;
}
