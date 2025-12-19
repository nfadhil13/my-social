import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class FDLOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const FDLOutlineButton({
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

    final button = OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: enabled ? colors.onSurface : colors.onSurfaceVariant,
        disabledBackgroundColor: colors.surface,
        disabledForegroundColor: colors.onSurfaceVariant,
        side: BorderSide(
          color: enabled ? colors.outline : colors.outline,
          width: 1,
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        text,
        style: textStyles.button.bold.applyColor(
          enabled ? colors.onSurface : colors.onSurfaceVariant,
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}
