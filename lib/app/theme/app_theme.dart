import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart'; // Import this!

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accent,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.headline,
      bodyMedium: AppTextStyles.body,
    ),
  );
}
