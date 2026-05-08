import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds
  static const Color scaffold = Color(0xFF1C1C1D);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color surfaceElevated = Color(0xFF2E2D2D);
  static const Color card = Color(0xFF1E1E22);

  // Accent
  static const Color primary = Color(0xFF0065FF);
  static const Color primaryLight = Color(0xFF3B82F6);

  // Status
  static const Color income = Color(0xFF3B82F6);
  static const Color expense = Color(0xFFC40C00);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textSmall = Color(0xFFBCBCBD);

  // Divider / border
  static const Color border = Color(0xFF272729);

  // Chart
  static const Color chartLine = Color(0xFF6BA6FF);
  static const Color chartFillTop = Color(0xFF0065FF);
  static const Color chartFillBottom = Color(0x003B82F6);
  static const Color tooltipBg = Colors.white;
}

abstract class AppSizes {
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusX = 28;
  static const double radiusCard = 20;

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;

  static const double cardHeight = 180.0;
  static const double bankCardWidth = 262.0;
  static const double bankCardHeight = 148.0;
}


abstract class AppTextStyles {
  static const String _font = 'Arimo';

  //MARK: Heading 
  
  static const TextStyle headingXl = TextStyle(
    fontFamily: _font,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingMd = TextStyle(
    fontFamily: _font,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headind22 = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingX = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingSm = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading28 = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingXs = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading13 = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  //MARK: Body 
  
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body11 = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body17 = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle body22 = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLgMedium = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMdMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmMedium = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle body12 = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyXX = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyS = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );


  //MARK: Small 

  static const TextStyle small22 = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
    
  );

  static const TextStyle small13 = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
    
  );
  
  static const TextStyle smallMd = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
    
  );

  static const TextStyle smallMdMedium = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSmall,
    
  );

  static const TextStyle smallSm = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
    
  );

  static const TextStyle smallSmMedium = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSmall,
  
  );

  static const TextStyle smallXs = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
   
  );

  static const TextStyle smallXxs = TextStyle(
    fontFamily: _font,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: AppColors.textSmall,
   
  );
}

abstract class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration page = Duration(milliseconds: 350);
}