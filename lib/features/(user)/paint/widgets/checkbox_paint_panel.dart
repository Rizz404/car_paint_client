import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CheckboxPaintPanel extends StatefulWidget {
  const CheckboxPaintPanel({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.price,
    required this.value,
    required this.onChanged,
    this.isImageNetwork = true,
  });
  final String imageAsset;
  final String title;
  final String price;
  final bool value;
  final bool isImageNetwork;
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
            widget.isImageNetwork
                ? ImageNetwork(
                    src: widget.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
            Positioned(
              bottom: 40,
              child: MainText(
                text: widget.title,
                customTextStyle: TextStyle(
                  fontSize: 36,
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
            Positioned(
              bottom: 0,
              child: MainText(
                text: CurrencyFormatter.toRupiah(
                  double.parse(widget.price),
                ),
                customTextStyle: TextStyle(
                  fontSize: 36,
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
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                child: Checkbox(
                  value: widget.value,
                  onChanged: widget.onChanged,
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
            ),
          ],
        ),
      ),
    );
  }
}
