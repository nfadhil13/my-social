import 'dart:ui';

extension ColorExtension on Color {
  Color applyOpacity(double opacity) => withAlpha((opacity * 255).round());
}
