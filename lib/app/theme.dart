import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffold,
      primaryColor: AppColors.primary,
      fontFamily: 'Arimo',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        background: AppColors.scaffold,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge:  AppTextStyles.headingXl,
        displayMedium: AppTextStyles.headingLg,
        displaySmall:  AppTextStyles.headingMd,
        headlineMedium: AppTextStyles.headingSm,
        headlineSmall:  AppTextStyles.headingXs,
        titleLarge:   AppTextStyles.bodyLgMedium,
        titleMedium:  AppTextStyles.bodyMdMedium,
        titleSmall:   AppTextStyles.bodySmMedium,
        bodyLarge:    AppTextStyles.bodyLg,
        bodyMedium:   AppTextStyles.bodyMd,
        bodySmall:    AppTextStyles.bodySm,
        labelLarge:   AppTextStyles.smallMdMedium,
        labelMedium:  AppTextStyles.smallSm,
        labelSmall:   AppTextStyles.smallXs,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffold,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headingSm,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Colors.white;
          return AppColors.textSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return AppColors.primary;
          return AppColors.surfaceElevated;
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}