import 'package:fdl_ui/ext/color.dart';
import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class FDLCardContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const FDLCardContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: colors.onBackground.applyOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
