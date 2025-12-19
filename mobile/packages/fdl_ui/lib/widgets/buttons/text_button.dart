import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class FDLTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const FDLTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Text(
        text,
        style: textStyles.p
            .applyColor(enabled ? colors.primary : colors.onSurfaceVariant)
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
