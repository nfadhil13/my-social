import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

extension MessengerExtension on BuildContext {
  void showSuccessSnackbar(String message) {
    final colors = this.colors;
    final textStyles = this.textStyles;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyles.p.applyColor(colors.onSuccess),
        ),
        backgroundColor: colors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showErrorSnackbar(String message) {
    final colors = this.colors;
    final textStyles = this.textStyles;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: textStyles.p.applyColor(colors.onError)),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
