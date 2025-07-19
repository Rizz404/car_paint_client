import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
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
          color: context.adaptiveCommonColor,
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withAlpha(25),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            widget.isImageNetwork
                ? ImageNetwork(
                    src: widget.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ).paddingSymmetric(vertical: 16)
                : Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ).paddingSymmetric(vertical: 16),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainText(
                      text: widget.title,
                      customTextStyle: TextStyle(
                        fontSize: 20,
                        color: context.adaptiveTertiaryColor,
                      ),
                      extent: const Medium(),
                    ),
                    Expanded(
                      child: MainText(
                        text: CurrencyFormatter.toRupiah(
                          double.parse(widget.price),
                        ),
                        extent: const Medium(),
                        customTextStyle: TextStyle(
                          fontSize: 20,
                          color: context.adaptiveTertiaryColor,
                        ),
                        textAlign: TextAlign.end,
                      ),
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
                    (states) => const BorderSide(),
                  ),
                  shape: const CircleBorder(),
                  activeColor: CustomColors.guideRed,
                  checkColor: context.adaptiveCommonColor,
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) => context.adaptiveTertiaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
