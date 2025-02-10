String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Model year cannot be empty";
  }
  if (!RegExp(r'^\d+$').hasMatch(value)) {
    return "Please enter a valid year (numbers only)";
  }

  return null;
}
