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
        height: 300,
        decoration: BoxDecoration(
          color: context.adaptivePrimaryCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withAlpha(25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.scale(
                  scale: 1,
                  child: Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: MainText(
                  text: widget.title,
                  customTextStyle: TextStyle(
                    fontSize: 48,
                    color: context.adaptiveSecondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
    );
  }
}
