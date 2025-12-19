import 'package:flutter/material.dart';

/// Tailwind CSS breakpoints
class BreakPoints {
  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
  static const double xxl = 1536;

  /// Get responsive value based on breakpoints (mobile-first)
  /// xs/base: < 640px, sm: >= 640px, md: >= 768px, lg: >= 1024px, xl: >= 1280px, xxl: >= 1536px
  static T breakpoint<T>(
    BuildContext context, {
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= BreakPoints.xxl) return xxl ?? xl ?? lg ?? md ?? sm ?? xs;
    if (width >= BreakPoints.xl) return xl ?? lg ?? md ?? sm ?? xs;
    if (width >= BreakPoints.lg) return lg ?? md ?? sm ?? xs;
    if (width >= BreakPoints.md) return md ?? sm ?? xs;
    if (width >= BreakPoints.sm) return sm ?? xs;
    return xs;
  }
}

class BreakPointWidget extends StatelessWidget {
  final Widget xs;
  final Widget? sm;
  final Widget? md;
  final Widget? lg;
  final Widget? xl;
  final Widget? xxl;
  const BreakPointWidget({
    super.key,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  @override
  Widget build(BuildContext context) {
    return BreakPoints.breakpoint(
      context,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
    );
  }
}
