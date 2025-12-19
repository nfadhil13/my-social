import 'package:flutter/material.dart';

class FDLForm<Result, SubmitResult extends Object?> extends StatefulWidget {
  final Result initialData;
  final Widget child;
  final AutovalidateMode? autovalidateMode;
  final void Function(FDLFormSubmit<Result, SubmitResult> submitResult)?
  onChange;
  final void Function(FDLFormSubmit<Result, SubmitResult> submitResult)?
  onSubmit;

  const FDLForm({
    super.key,
    required this.initialData,
    this.autovalidateMode,
    this.onChange,
    required this.child,
    this.onSubmit,
  });

  @override
  State<FDLForm<Result, SubmitResult>> createState() =>
      _FDLFormState<Result, SubmitResult>();
}

class _FDLFormState<Result, T extends Object?>
    extends State<FDLForm<Result, T>> {
  final _formKey = GlobalKey<FormState>();

  Map<String, String> _errors = {};
  late Result _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialData;
  }

  void _save() {
    _formKey.currentState?.save();
  }

  void _submit([T? result]) {
    _save();
    widget.onSubmit?.call(
      FDLFormSubmit(
        value: _value,
        validate: _validate,
        setError: _setError,
        submitResult: result,
      ),
    );
  }

  void _setValue(Result value) {
    setState(() {
      _value = value;
    });
  }

  bool _validate() {
    final currentState = _formKey.currentState;
    if (currentState == null) return false;
    return currentState.validate();
  }

  void _setError(Map<String, String> errors) {
    setState(() {
      _errors = errors;
    });
  }

  String? _lazyErrors(String key) => _errors[key];

  @override
  Widget build(BuildContext context) {
    return FDLFormScope<Result, T>(
      allErrors: () => _errors,
      initialValue: widget.initialData,
      errors: _lazyErrors,
      value: () => _value,
      setValue: _setValue,
      save: _save,
      setError: _setError,
      submit: _submit,
      validate: _validate,
      child: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        onChanged: () {
          widget.onChange?.call(
            FDLFormSubmit(
              value: _value,
              validate: _validate,
              setError: _setError,
              submitResult: null,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class FDLFormSubmit<Result, SubmitResult extends Object?> {
  final Result value;
  final bool Function() validate;
  final void Function(Map<String, String> errors) setError;
  final SubmitResult? submitResult;

  const FDLFormSubmit({
    required this.value,
    required this.validate,
    required this.setError,
    this.submitResult,
  });
}

class FDLFormScope<Result, T extends Object?> extends InheritedWidget {
  final Result initialValue;
  final Result Function() _value;
  final void Function([T? result]) submit;
  final bool Function() validate;
  final VoidCallback save;
  final void Function(Map<String, String> errors) setError;
  final String? Function(String key) errors;
  final Map<String, String> Function() allErrors;
  final void Function(Result value) setValue;

  const FDLFormScope({
    super.key,
    required super.child,
    required this.initialValue,
    required Result Function() value,
    required this.save,
    required this.submit,
    required this.setValue,
    required this.allErrors,
    required this.validate,
    required this.errors,
    required this.setError,
  }) : _value = value;

  Result get value => _value();

  static FDLFormScope<Result, T> of<Result, T extends Object?>(
    BuildContext context,
  ) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<FDLFormScope<Result, T>>();
    if (widget == null) {
      throw Exception('Cannot find FDLFormScope in the widget tree');
    }
    return widget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

extension FDLFormContextExt on BuildContext {
  FDLFormScope<Result, Object?> fdlForm<Result>() =>
      FDLFormScope.of<Result, Object?>(this);

  FDLFormScope<Result, T> fdlFormWithSubmit<Result, T extends Object>() =>
      FDLFormScope.of<Result, T>(this);
}
