import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class MainElevatedButton extends StatelessWidget {
  const MainElevatedButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.text,
    this.extent = const Medium(),
    this.width = double.infinity,
    this.height = 46.0,
    this.borderRadius = 16.0,
  });
  final Extent extent;
  final bool isLoading;
  final void Function()? onPressed;
  final String text;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(width, height)),
      ),
      child: MainText(text: text, extent: extent),
    );
  }
}
