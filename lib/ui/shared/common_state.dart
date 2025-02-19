import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CommonState extends StatelessWidget {
  final String imgPath;
  final String title;
  final String? description;

  const CommonState({
    super.key,
    this.imgPath = 'assets/images/empty_data.png',
    this.title = "No data found",
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Image(image: AssetImage(imgPath)),
          Column(
            spacing: 8,
            children: [
              MainText(
                text: title,
                textAlign: TextAlign.center,
                extent: const Medium(),
                maxLines: 3,
              ),
              if (description != null)
                MainText(
                  text: description!,
                  textAlign: TextAlign.center,
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
            ],
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16);
  }
}
