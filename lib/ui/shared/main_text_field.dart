import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? CustomColors.pureWhite
                      : CustomColors.pureBlack,
                ),
              )
            : null,
        enabledBorder: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? CustomColors.pureWhite
                      : CustomColors.pureBlack,
                ),
              )
            : null,
        focusedBorder: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? CustomColors.pureWhite
                      : CustomColors.pureBlack,
                ),
              )
            : null,
        disabledBorder: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? CustomColors.pureWhite
                      : CustomColors.pureBlack,
                ),
              )
            : null,
        alignLabelWithHint: true,
        labelText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
    );
  }
}
