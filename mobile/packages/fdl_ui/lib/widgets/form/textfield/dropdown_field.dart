import 'package:fdl_ui/styles/style.dart';
import 'package:fdl_ui/widgets/form/field_decoration.dart';
import 'package:fdl_ui/widgets/form/form_wrapper.dart';
import 'package:flutter/material.dart';

class FDLDropdownField<T> extends StatelessWidget {
  final T? value;
  final String? label;
  final String? hint;
  final IconData? icon;
  final List<FDLDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final FormFieldSaved<T>? onSaved;
  final FormFieldValidator<T?>? validator;

  const FDLDropdownField({
    super.key,
    this.value,
    this.label,
    this.hint,
    this.icon,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return FDLFormWrapper(
      label: label,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item.value,
            child: Text(
              item.label,
              style: textStyles.input.applyColor(colors.onSurface),
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        onSaved: onSaved != null ? (value) => onSaved!(value) : null,
        validator: validator,
        style: textStyles.input.applyColor(colors.onSurface),
        decoration: FDLFieldDecoration.build(
          context: context,
          hint: hint,
          prefixIcon: icon,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: colors.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class FDLDropdownItem<T> {
  final T value;
  final String label;

  const FDLDropdownItem({required this.value, required this.label});
}
