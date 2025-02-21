import 'package:flutter/material.dart';

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
        color: Theme.of(context).colorScheme.secondary,
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
