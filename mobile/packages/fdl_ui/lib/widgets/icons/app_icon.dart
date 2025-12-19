import 'package:fdl_ui/styles/style.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;
  const AppIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('⚡', style: TextStyle(fontSize: size * 0.6)),
      ),
    );
  }
}
