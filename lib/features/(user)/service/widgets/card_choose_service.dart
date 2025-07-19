import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CardChooseService extends StatefulWidget {
  const CardChooseService({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.onTap,
    this.isDisabled = false,
  });
  final bool isDisabled;
  final String imageAsset;
  final String title;
  final Function() onTap;
  @override
  State<CardChooseService> createState() => _CardChooseServiceState();
}

class _CardChooseServiceState extends State<CardChooseService> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColors.pureWhite,
          borderRadius: BorderRadius.circular(24),
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
            Image.asset(
              widget.imageAsset,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 16,
              bottom: -20,
              child: MainText(
                text: widget.title,
                customTextStyle: TextStyle(
                  fontSize: 48,
                  color: CustomColors.guideDarkGray,
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
        ).paddingSymmetric(vertical: 20),
      ),
    );
  }
}
