String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Model year cannot be empty";
  }
  if (!RegExp(r'^\d+$').hasMatch(value)) {
    return "Please enter a valid year (numbers only)";
  }
  int year = int.parse(value);
  if (year < 1886 || year > DateTime.now().year + 1) {
    // Tahun 1886 = mobil pertama
    return "Please enter a valid model year (1886 - ${DateTime.now().year + 1})";
  }
  return null;
}
