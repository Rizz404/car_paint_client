import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

AppBar mainAppBar(String title) {
  return AppBar(
    centerTitle: true,

    backgroundColor: const Color(0xF2F2F2F2), // ! secondary
    title: MainText(
      text: title,
      extent: const Large(),
    ),
  );
}
