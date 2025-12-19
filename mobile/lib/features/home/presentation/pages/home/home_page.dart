import 'package:fdl_ui/fdl_ui.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            'Home',
            style: textStyles.h1.bold.applyColor(colors.onSurface),
          ),
        ),
      ),
    );
  }
}
