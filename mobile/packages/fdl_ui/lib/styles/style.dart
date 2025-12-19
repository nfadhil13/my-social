import 'package:flutter/material.dart';

part 'color.dart';
part 'text_style.dart';

class FDLStyleProvider extends StatefulWidget {
  final AppColors? colors;
  final AppTextStyles? textStyles;
  final Widget child;
  const FDLStyleProvider({
    super.key,
    this.colors,
    this.textStyles,
    required this.child,
  });

  static FDLStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FDLStyle>()!;
  }

  @override
  State<FDLStyleProvider> createState() => _FDLStyleProviderState();
}

class _FDLStyleProviderState extends State<FDLStyleProvider> {
  late AppColors colors;
  late AppTextStyles textStyles;

  @override
  void initState() {
    super.initState();
    colors = widget.colors ?? AppColors.defaultColors;
    textStyles = widget.textStyles ?? AppTextStyles.defaultTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    return FDLStyle(
      colors: colors,
      textStyles: textStyles,
      child: widget.child,
    );
  }
}

class FDLStyle extends InheritedWidget {
  final AppColors colors;
  final AppTextStyles textStyles;
  const FDLStyle({
    super.key,
    required this.colors,
    required this.textStyles,
    required super.child,
  });

  @override
  bool updateShouldNotify(FDLStyle oldWidget) {
    return false;
  }
}

extension FDLStyleExtension on BuildContext {
  AppColors get colors => FDLStyleProvider.of(this).colors;
  AppTextStyles get textStyles => FDLStyleProvider.of(this).textStyles;
}
