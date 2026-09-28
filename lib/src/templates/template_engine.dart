import 'dart:io';
import 'package:path/path.dart' as p;

/// Fast, dependency-free template renderer supporting variables and conditionals.
class TemplateEngine {
  TemplateEngine._();

  /// Renders a mustache-style [template] string with provided [context] map.
  ///
  /// Supports:
  /// - Variables: `{{variable_name}}`
  /// - Conditionals: `{{#is_active}}...{{/is_active}}`
  /// - Inverted conditionals: `{{^is_active}}...{{/is_active}}`
  static String render(String template, Map<String, dynamic> context) {
    var output = template;

    // Process positive conditionals: {{#key}}content{{/key}}
    final sectionRegex =
        RegExp(r'\{\{#([a-zA-Z0-9_]+)\}\}([\s\S]*?)\{\{/\1\}\}');
    output = output.replaceAllMapped(sectionRegex, (match) {
      final key = match.group(1)!;
      final content = match.group(2)!;
      final val = context[key];
      final isTrue = val != null &&
          val != false &&
          (val is! String || val.isNotEmpty) &&
          (val is! List || val.isNotEmpty);
      return isTrue ? content : '';
    });

    // Process inverted conditionals: {{^key}}content{{/key}}
    final invertedRegex =
        RegExp(r'\{\{\^([a-zA-Z0-9_]+)\}\}([\s\S]*?)\{\{/\1\}\}');
    output = output.replaceAllMapped(invertedRegex, (match) {
      final key = match.group(1)!;
      final content = match.group(2)!;
      final val = context[key];
      final isFalse = val == null ||
          val == false ||
          (val is String && val.isEmpty) ||
          (val is List && val.isEmpty);
      return isFalse ? content : '';
    });

    // Process variable substitutions: {{key}}
    final varRegex = RegExp(r'\{\{([a-zA-Z0-9_]+)\}\}');
    output = output.replaceAllMapped(varRegex, (match) {
      final key = match.group(1)!;
      if (context.containsKey(key)) {
        return context[key]?.toString() ?? '';
      }
      return match.group(0)!;
    });

    return output;
  }

  /// Resolves template content either from custom local folder if it exists,
  /// or from default built-in template string.
  static String resolveTemplate({
    required String templateName,
    required String defaultContent,
    String? customPath,
    Directory? projectDir,
  }) {
    if (customPath != null && customPath.isNotEmpty) {
      final customFile = File(
        p.isAbsolute(customPath)
            ? p.join(customPath, templateName)
            : p.join((projectDir ?? Directory.current).path, customPath,
                templateName),
      );
      if (customFile.existsSync()) {
        return customFile.readAsStringSync();
      }
    }

    // Also check standard .flutter_architect/templates/<templateName>
    final localOverride = File(
      p.join((projectDir ?? Directory.current).path, '.flutter_architect',
          'templates', templateName),
    );
    if (localOverride.existsSync()) {
      return localOverride.readAsStringSync();
    }

    return defaultContent;
  }
}
