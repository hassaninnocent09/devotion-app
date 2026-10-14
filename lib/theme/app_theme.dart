import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  AppTheme._();

  /// Edge-to-edge: transparent bars with dark icons (light UI everywhere).
  static const overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  static ThemeData get light {
    const swipeBack = CupertinoPageTransitionsBuilder();
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppText.sans,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.green,
        onPrimary: Colors.white,
        surface: AppColors.background,
        onSurface: AppColors.ink,
      ),
      splashFactory: InkRipple.splashFactory,
      splashColor: const Color(0x14355539),
      highlightColor: const Color(0x0F355539),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: swipeBack,
        TargetPlatform.iOS: swipeBack,
        TargetPlatform.macOS: swipeBack,
        TargetPlatform.windows: swipeBack,
        TargetPlatform.linux: swipeBack,
        TargetPlatform.fuchsia: swipeBack,
      }),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        contentTextStyle: AppText.t(13, w: FontWeight.w500, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.green,
        selectionColor: Color(0x33355539),
        selectionHandleColor: AppColors.green,
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: AppColors.background,
        hourMinuteColor: AppColors.field,
        dialBackgroundColor: AppColors.field,
      ),
    );
  }
}
