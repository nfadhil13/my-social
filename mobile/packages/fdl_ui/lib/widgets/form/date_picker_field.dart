import 'package:fdl_ui/styles/style.dart';
import 'package:fdl_ui/widgets/form/field_decoration.dart';
import 'package:fdl_ui/widgets/form/form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FDLDatePickerField extends StatefulWidget {
  final String? label;
  final String? hint;
  final IconData? icon;
  final ValueChanged<DateTime>? onChanged;
  final bool enabled;
  final FormFieldSaved<DateTime>? onSaved;
  final FormFieldValidator<DateTime?>? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialValue;

  const FDLDatePickerField({
    super.key,
    this.label,
    this.hint,
    this.icon,
    this.onChanged,
    this.enabled = true,
    this.onSaved,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.initialValue,
  });

  @override
  State<FDLDatePickerField> createState() => _FDLDatePickerFieldState();
}

class _FDLDatePickerFieldState extends State<FDLDatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedDate = widget.initialValue;
    _updateController();
  }

  @override
  void didUpdateWidget(FDLDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedDate = widget.initialValue;
      _updateController();
    }
  }

  void _updateController() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    _controller.text = _selectedDate != null
        ? dateFormat.format(_selectedDate!)
        : '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    if (!widget.enabled) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialValue ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate:
          widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
              onPrimary: context.colors.onPrimary,
              surface: context.colors.surface,
              onSurface: context.colors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
      _updateController();
    });

    if (widget.onChanged != null) {
      widget.onChanged!(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return FDLFormWrapper(
      label: widget.label,
      child: InkWell(
        onTap: () => _showDatePicker(context),
        child: AbsorbPointer(
          child: TextFormField(
            enabled: widget.enabled,
            controller: _controller,
            validator: widget.validator != null
                ? (value) => widget.validator!(_selectedDate)
                : null,
            onSaved: widget.onSaved != null
                ? (value) => widget.onSaved!(_selectedDate)
                : null,
            style: textStyles.input.applyColor(colors.onSurface),
            decoration: FDLFieldDecoration.build(
              context: context,
              hint: widget.hint,
              prefixIcon: widget.icon,
              suffixIcon: Icon(
                Icons.calendar_today,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
