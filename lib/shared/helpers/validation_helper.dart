class ValidationHelper {
  ValidationHelper._();

  static String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static int countWords(String input) {
    final sanitized = sanitizeInput(input);
    if (sanitized.isEmpty) return 0;
    return sanitized.split(' ').length;
  }

  static bool isValidInput(String input, {int minWords = 10}) {
    return countWords(input) >= minWords;
  }
}
