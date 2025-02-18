import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CardMiniLinkSection extends StatelessWidget {
  const CardMiniLinkSection({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
  });
  final String image;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 1), // x,y
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      image,
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
                MainText(
                  text: text,
                  extent: const Medium(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
