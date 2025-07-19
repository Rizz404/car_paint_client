import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';

class GradientBgAuth extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GradientBgAuth({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.adaptiveBackgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: child,
        ),
      ),
    );
  }
}
