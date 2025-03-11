import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CheckboxPaintPanel extends StatefulWidget {
  const CheckboxPaintPanel({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String imageAsset;
  final String title;
  final bool value;
  final Function(bool?) onChanged;
  @override
  State<CheckboxPaintPanel> createState() => _CheckboxPaintPanelState();
}

class _CheckboxPaintPanelState extends State<CheckboxPaintPanel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: CustomColors.secondaryWhite,
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withAlpha(25),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                // Gunakan MaterialStateProperty untuk side
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    color: CustomColors.gray,
                    width: 2,
                  ),
                ),
                shape: const CircleBorder(),
                checkColor: CustomColors.blue,
                activeColor: CustomColors.blue,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return CustomColors.blue;
                  }
                  return CustomColors.gray;
                }),
              ),
            ),
            Image.asset(
              widget.imageAsset,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: MainText(
                text: widget.title,
                customTextStyle: TextStyle(
                  fontSize: 48,
                  color: CustomColors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: CustomColors.black.withAlpha(50),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
