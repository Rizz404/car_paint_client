String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Model year cannot be empty";
  }

  return null;
}
