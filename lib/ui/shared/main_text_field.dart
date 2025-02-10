import 'package:flutter/material.dart';
import 'package:paint_car/core/types/validator.dart';

class MainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool? obscureText;
  final Validator? validator;
  final int maxLines;
  final bool isEnabled;
  final TextInputType keyboardType;
  const MainTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.trailingIcon,
    this.leadingIcon,
    this.obscureText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: trailingIcon,
        prefixIcon: leadingIcon,
        enabled: isEnabled,
        alignLabelWithHint: true,

        // ! nge align icon dengan text
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ), // Tambahkan ini
      ),
    );
  }
}
