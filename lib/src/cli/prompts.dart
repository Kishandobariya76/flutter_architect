import 'dart:io';
import 'logger.dart';

/// Interactive CLI prompting helper with fallback for non-interactive environments.
class Prompts {
  final Logger logger;
  final Stdin _stdin;
  final bool? _forceInteractive;

  Prompts({
    Logger? logger,
    Stdin? customStdin,
    bool? forceInteractive,
  })  : logger = logger ?? Logger(),
        _stdin = customStdin ?? stdin,
        _forceInteractive = forceInteractive;

  bool get isInteractive =>
      _forceInteractive ??
      (_stdin.hasTerminal &&
          Platform.environment['TERM'] != 'dumb' &&
          Platform.environment['CI'] == null);

  /// Prompts user to select an option from a list.
  String select({
    required String prompt,
    required List<String> options,
    String? defaultValue,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options cannot be empty');
    }

    final defaultOpt = defaultValue != null && options.contains(defaultValue)
        ? defaultValue
        : options.first;

    if (!isInteractive) {
      return defaultOpt;
    }

    logger.info('');
    logger.highlight('? $prompt:');
    for (var i = 0; i < options.length; i++) {
      final isDefault = options[i] == defaultOpt;
      final prefix = isDefault ? '  > ' : '    ';
      logger.info('$prefix${i + 1}) ${options[i]}');
    }

    stdout.write(
        '  Enter selection (1-${options.length}) [default: ${options.indexOf(defaultOpt) + 1}]: ');
    final input = _stdin.readLineSync()?.trim();
    if (input == null || input.isEmpty) {
      return defaultOpt;
    }

    final index = int.tryParse(input);
    if (index != null && index >= 1 && index <= options.length) {
      return options[index - 1];
    }

    // Check if input matches option name directly
    final directMatch = options.firstWhere(
      (opt) => opt.toLowerCase() == input.toLowerCase(),
      orElse: () => '',
    );
    if (directMatch.isNotEmpty) {
      return directMatch;
    }

    logger.warning('Invalid selection. Using default: $defaultOpt');
    return defaultOpt;
  }

  /// Prompts user for a yes/no boolean confirmation.
  bool confirm({
    required String prompt,
    bool defaultValue = true,
  }) {
    if (!isInteractive) {
      return defaultValue;
    }

    final hint = defaultValue ? '(Y/n)' : '(y/N)';
    stdout.write('? $prompt $hint: ');
    final input = _stdin.readLineSync()?.trim().toLowerCase();

    if (input == null || input.isEmpty) {
      return defaultValue;
    }

    return input == 'y' || input == 'yes';
  }

  /// Prompts user for a freeform text input with optional validator and default.
  String text({
    required String prompt,
    String? defaultValue,
    String? Function(String)? validator,
  }) {
    if (!isInteractive) {
      return defaultValue ?? '';
    }

    while (true) {
      final hint = defaultValue != null ? ' [$defaultValue]' : '';
      stdout.write('? $prompt$hint: ');
      final input = _stdin.readLineSync()?.trim();

      final result =
          (input == null || input.isEmpty) ? (defaultValue ?? '') : input;

      if (validator != null) {
        final error = validator(result);
        if (error != null) {
          logger.error(error);
          continue;
        }
      }

      return result;
    }
  }

  /// Decision when file conflict occurs: skip, overwrite, rename.
  FileConflictAction resolveConflict({
    required String filePath,
    bool force = false,
    bool skipExisting = false,
  }) {
    if (force) return FileConflictAction.overwrite;
    if (skipExisting) return FileConflictAction.skip;
    if (!isInteractive) return FileConflictAction.skip;

    logger.warning('File already exists: $filePath');
    final choice = select(
      prompt: 'What would you like to do?',
      options: ['Skip', 'Overwrite'],
      defaultValue: 'Skip',
    );

    return choice == 'Overwrite'
        ? FileConflictAction.overwrite
        : FileConflictAction.skip;
  }
}

enum FileConflictAction {
  skip,
  overwrite,
}
