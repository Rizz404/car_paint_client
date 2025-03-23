import 'package:flutter/material.dart';
import 'package:paint_car/core/types/validator.dart';

class MainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool? obscureText;
  final Validator? validator;
  final int maxLines;
  final bool isEnabled;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool isOutlined;
  final double borderRadius;
  final String? prefixText;
  const MainTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.trailingIcon,
    this.onChanged,
    this.leadingIcon,
    this.obscureText,
    this.validator,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isEnabled = true,
    this.isOutlined = true,
    this.borderRadius = 10,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: trailingIcon,
        prefixIcon: leadingIcon,
        prefixText: prefixText,
        enabled: isEnabled,
        border: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius,
                ),
              )
            : null,

        alignLabelWithHint: true,
        // ! ganti ama label text boleh
        labelText: hintText,

        // ! nge align icon dengan text
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ), // Tambahkan ini
      ),
    );
  }
}
