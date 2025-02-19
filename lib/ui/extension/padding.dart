import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  /// Memberikan padding sesuai nilai yang diinginkan.
  Widget paddingAll([double value = 16.0]) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );
  Widget paddingSymmetric({double vertical = 0, double horizontal = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );
}
