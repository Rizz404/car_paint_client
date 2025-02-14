import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/helper/base_text.dart';

class MainText extends BaseText {
  const MainText({
    super.key,
    required super.text,
    super.extent = const Small(),
    super.customTextStyle,
    super.textAlign = TextAlign.left,
    super.maxLines = 1,
    super.overflow = TextOverflow.ellipsis,
    super.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: textStyle(context)!.copyWith(
        color: color,
      ),
    );
  }
}
