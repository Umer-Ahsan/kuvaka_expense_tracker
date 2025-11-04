import 'package:flutter/material.dart';
import 'package:kuvaka_expense_tracker/constants/colors.dart';

class AppThemes {
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.white,
    background: AppColors.backgroundColorLight,
    onBackground: AppColors.textColorLight,
    surface: Colors.white,
    onSurface: AppColors.textColorLight,
    error: Colors.red,
    onError: Colors.white,
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.black,
    background: AppColors.backgroundColorDark,
    onBackground: AppColors.textColorDark,
    surface: const Color(0xFF1E1E1E),
    onSurface: AppColors.textColorDark,
    error: Colors.redAccent,
    onError: Colors.white,
  );

  static ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundColorLight,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        iconTheme: const IconThemeData(color: AppColors.textColorLight),
        titleTextStyle: const TextStyle(
          color: AppColors.textColorDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textColorLight),
        bodyMedium: TextStyle(color: Color(0xFF3C3C3C)),
      ),
      cardColor: lightColorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.backgroundColorDark,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        iconTheme: const IconThemeData(color: AppColors.textColorDark),
        titleTextStyle: const TextStyle(
          color: AppColors.textColorDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textColorDark),
        bodyMedium: TextStyle(color: Color(0xFFA1A1AA)),
      ),
      cardColor: darkColorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
