import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class FDLFieldDecoration {
  static InputDecoration build({
    required BuildContext context,
    String? hint,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return InputDecoration(
      hintText: hint,
      hintStyle: textStyles.input.applyColor(colors.onSurfaceVariant),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: colors.onSurfaceVariant)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      errorStyle: textStyles.p.medium
          .applyColor(colors.error)
          .copyWith(fontSize: 12),
      fillColor: colors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.primary, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.outline, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
