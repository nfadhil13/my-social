import 'package:fdl_ui/styles/style.dart';
import 'package:fdl_ui/widgets/buttons/filled_button.dart';
import 'package:flutter/material.dart';

class FDLErrorWidget extends StatelessWidget {
  final String? message;
  final String? retryText;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool isCenter;

  const FDLErrorWidget({
    super.key,
    this.message,
    this.retryText,
    this.onRetry,
    this.icon,
    this.isCenter = true,
  }) : assert(message != null, 'Message must be provided');

  factory FDLErrorWidget.fromMessage(
    String message, {
    String? retryText,
    VoidCallback? onRetry,
    IconData? icon,
    bool isCenter = true,
  }) {
    return FDLErrorWidget(
      message: message,
      retryText: retryText,
      onRetry: onRetry,
      icon: icon,
      isCenter: isCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final errorMessage = message ?? '';
    final errorIcon = icon ?? Icons.error_outline;

    Widget content = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(errorIcon, color: colors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: textStyles.p.applyColor(colors.onSurface),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FDLFilledButton(text: retryText ?? 'Retry', onPressed: onRetry),
          ],
        ],
      ),
    );

    if (isCenter) {
      return Center(child: content);
    }

    return content;
  }
}
