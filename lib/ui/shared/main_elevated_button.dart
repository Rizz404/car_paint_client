import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class MainElevatedButton extends StatelessWidget {
  const MainElevatedButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.text,
    this.bgColor,
    this.extent = const Medium(),
    this.width = double.infinity,
    this.height = 46.0,
    this.textColor = Colors.white,
    this.borderRadius = 16.0,
  });
  final Extent extent;
  final bool isLoading;
  final void Function()? onPressed;
  final String text;
  final Color textColor;
  final Color? bgColor;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: isLoading
            ? WidgetStateProperty.all(Colors.grey)
            : WidgetStateProperty.all(
                bgColor ?? Theme.of(context).colorScheme.primary,
              ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(width, height)),
      ),
      child: MainText(text: text, extent: extent, color: textColor),
    );
  }
}
