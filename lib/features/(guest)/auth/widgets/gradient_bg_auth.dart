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
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.primary,
          ],
          stops: [0.2, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
