import 'package:fdl_ui/styles/style.dart';
import 'package:fdl_ui/widgets/form/field_decoration.dart';
import 'package:fdl_ui/widgets/form/form_wrapper.dart';
import 'package:flutter/material.dart';

class FDLTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffixIcon;
  final FormFieldSaved<String>? onSaved;
  final FormFieldValidator<String?>? validator;

  const FDLTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return FDLFormWrapper(
      label: label,
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        style: textStyles.input.applyColor(colors.onSurface),
        decoration: FDLFieldDecoration.build(
          context: context,
          hint: hint,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
