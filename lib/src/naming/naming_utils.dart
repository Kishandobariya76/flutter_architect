/// Robust naming conversion utility for Dart identifiers and file names.
class NamingUtils {
  NamingUtils._();

  /// Splits an input string into words across kebab, snake, camel, pascal,
  /// space, dot, and screaming cases.
  static List<String> splitWords(String input) {
    if (input.trim().isEmpty) return [];

    final cleaned = input.trim();
    final words = <String>[];
    final buffer = StringBuffer();

    for (var i = 0; i < cleaned.length; i++) {
      final char = cleaned[i];
      final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
      final isLower = char.toLowerCase() == char && char.toUpperCase() != char;
      final isDigit = int.tryParse(char) != null;
      final isSeparator = char == '_' ||
          char == '-' ||
          char == ' ' ||
          char == '.' ||
          char == '/' ||
          char == '\\';

      if (isSeparator) {
        if (buffer.isNotEmpty) {
          words.add(buffer.toString());
          buffer.clear();
        }
        continue;
      }

      if (isUpper) {
        final prevIsLower = i > 0 &&
            cleaned[i - 1].toLowerCase() == cleaned[i - 1] &&
            cleaned[i - 1].toUpperCase() != cleaned[i - 1];
        final nextIsLower = i + 1 < cleaned.length &&
            cleaned[i + 1].toLowerCase() == cleaned[i + 1] &&
            cleaned[i + 1].toUpperCase() != cleaned[i + 1];

        if (buffer.isNotEmpty && (prevIsLower || nextIsLower)) {
          words.add(buffer.toString());
          buffer.clear();
        }
        buffer.write(char);
      } else if (isLower || isDigit) {
        buffer.write(char);
      } else {
        if (buffer.isNotEmpty) {
          words.add(buffer.toString());
          buffer.clear();
        }
      }
    }

    if (buffer.isNotEmpty) {
      words.add(buffer.toString());
    }

    return words
        .map((w) => w.toLowerCase())
        .where((w) => w.isNotEmpty)
        .toList();
  }

  /// Converts input to snake_case (e.g. `user_profile`).
  static String toSnakeCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    return words.join('_');
  }

  /// Converts input to PascalCase (e.g. `UserProfile`).
  static String toPascalCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    return words.map((w) => capitalize(w)).join();
  }

  /// Converts input to camelCase (e.g. `userProfile`).
  static String toCamelCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    final first = words.first;
    final rest = words.skip(1).map((w) => capitalize(w)).join();
    return '$first$rest';
  }

  /// Converts input to kebab-case (e.g. `user-profile`).
  static String toKebabCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    return words.join('-');
  }

  /// Converts input to Title Case (e.g. `User Profile`).
  static String toTitleCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    return words.map((w) => capitalize(w)).join(' ');
  }

  /// Converts input to CONSTANT_CASE (e.g. `USER_PROFILE`).
  static String toConstantCase(String input) {
    final words = splitWords(input);
    if (words.isEmpty) return '';
    return words.map((w) => w.toUpperCase()).join('_');
  }

  /// Capitalizes first letter of string.
  static String capitalize(String word) {
    if (word.isEmpty) return word;
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }

  /// Validates whether an identifier is a valid Dart variable/class name fragment.
  static bool isValidIdentifier(String input) {
    final snake = toSnakeCase(input);
    if (snake.isEmpty) return false;
    // Cannot start with a digit
    if (RegExp(r'^[0-9]').hasMatch(snake)) return false;
    // Must be alphanumeric and underscores only
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(snake);
  }
}
