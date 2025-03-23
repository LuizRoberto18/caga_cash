import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.secondary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: AppTextStyles.title,
    ),
    textTheme: TextTheme(
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
    ),
  );
}
