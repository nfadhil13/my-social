part of 'style.dart';

abstract class AppColors {
  static AppColors get defaultColors => LightColors();

  // Background colors
  Color get background;
  Color get onBackground;

  // Surface colors
  Color get surface;
  Color get onSurface;
  Color get onSurfaceMuted;

  Color get surfaceVariant;
  Color get onSurfaceVariant;

  // Primary colors
  Color get primary;
  Color get onPrimary;

  // Error colors
  Color get error;
  Color get onError;

  // Success colors
  Color get success;
  Color get onSuccess;

  // Outline colors
  Color get outline;

  Color get warning;
  Color get onWarning;
}

class LightColors implements AppColors {
  // Background colors
  @override
  Color get background => const Color(0xFFE9EBEF);

  @override
  Color get onBackground => const Color(0xFF252525);

  // Surface colors
  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get onSurfaceMuted => const Color(0xFF64748b);

  @override
  Color get onSurface => const Color(0xFF252525);

  @override
  Color get surfaceVariant => const Color(0xFFF3F3F5);

  @override
  Color get onSurfaceVariant => const Color(0xFF717182);

  // Primary colors
  @override
  Color get primary => const Color(0xFF1ECFC9);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // Error colors
  @override
  Color get error => const Color(0xFFEF4444);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Success colors
  @override
  Color get success => const Color(0xFF10B981);

  @override
  Color get onSuccess => const Color(0xFFFFFFFF);

  // Outline colors
  @override
  Color get outline => const Color(0x1A000000);

  @override
  Color get warning => const Color(0xFFFFA500);

  @override
  Color get onWarning => const Color(0xFFFFFFFF);
}

class DarkColors implements AppColors {
  // Background colors
  @override
  Color get background => const Color(0xFF444444);

  @override
  Color get onBackground => const Color(0xFFFAFAFA);

  // Surface colors
  @override
  Color get surface => const Color(0xFF252525);

  @override
  Color get onSurface => const Color(0xFFFAFAFA);

  @override
  Color get surfaceVariant => const Color(0xFF444444);

  @override
  Color get onSurfaceVariant => const Color(0xFFB4B4B4);

  // Primary colors
  @override
  Color get primary => const Color(0xFF1ECFC9);

  @override
  Color get onPrimary => const Color(0xFF343434);

  // Error colors
  @override
  Color get error => const Color(0xFFF87171);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Success colors
  @override
  Color get success => const Color(0xFF34D399);

  @override
  Color get onSuccess => const Color(0xFF1F2937);

  // Outline colors
  @override
  Color get outline => const Color(0xFF444444);

  @override
  Color get onSurfaceMuted => const Color(0xFF64748b);

  @override
  Color get warning => const Color(0xFFFFA500);

  @override
  Color get onWarning => const Color(0xFF1F2937);
}
