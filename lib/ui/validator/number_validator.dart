String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Model year cannot be empty";
  }
  if (int.tryParse(value) == null) {
    return "Model year must be a number";
  }

  return null;
}
