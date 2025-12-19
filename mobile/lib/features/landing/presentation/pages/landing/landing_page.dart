import 'package:fdl_ui/fdl_ui.dart';
import 'package:my_social/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: textStyles.h1.bold.applyColor(colors.onSurface),
              ),
              const SizedBox(height: 32),
              FDLFilledButton(
                text: 'Login',
                onPressed: () => context.push(AppRoutes.login),
                width: 200,
              ),
              const SizedBox(height: 16),
              FDLOutlineButton(
                text: 'Register',
                onPressed: () => context.push(AppRoutes.register),
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
