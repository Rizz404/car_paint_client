import 'package:flutter/material.dart';

class DropdownState {
  final String title;
  final List<Map<String, dynamic>> items;
  final String subtitle;
  final IconData leadingIcon;

  DropdownState({
    required this.title,
    required this.items,
    required this.subtitle,
    required this.leadingIcon,
  });
}
