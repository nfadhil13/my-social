import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class FDLFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const FDLFilledButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.surfaceVariant,
        disabledForegroundColor: colors.onSurfaceVariant,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: textStyles.button.bold.applyColor(
          enabled ? colors.onPrimary : colors.onSurfaceVariant,
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}
