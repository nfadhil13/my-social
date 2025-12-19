import 'package:fdl_ui/styles/style.dart';
import 'package:fdl_ui/widgets/form/form_wrapper.dart';
import 'package:fdl_ui/widgets/form/textfield/textfield.dart';
import 'package:flutter/material.dart';

class FDLPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final FormFieldSaved<String>? onSaved;
  final FormFieldValidator<String?>? validator;

  const FDLPasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.icon,
    this.onChanged,
    this.enabled = true,
    this.onSaved,
    this.validator,
  });

  @override
  State<FDLPasswordField> createState() => _FDLPasswordFieldState();
}

class _FDLPasswordFieldState extends State<FDLPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FDLTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      icon: widget.icon,
      onSaved: widget.onSaved,
      validator: widget.validator,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: colors.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
