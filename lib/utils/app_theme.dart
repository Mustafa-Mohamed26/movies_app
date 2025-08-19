import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      iconTheme: const IconThemeData(color: AppColors.yellow),
      titleTextStyle: AppStyles.regular16yellow,
      centerTitle: true
    ),
    scaffoldBackgroundColor: AppColors.black,
  );
    
}