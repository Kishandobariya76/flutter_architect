import 'dart:io';
import 'package:path/path.dart' as p;
import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../naming/naming_utils.dart';

/// Appends a new endpoint definition to api_endpoints.dart.
class EndpointCommand extends BaseCommand {
  @override
  final String name = 'endpoint';

  @override
  final String description =
      'Register a new endpoint constant in lib/core/network/api_endpoints.dart.';

  @override
  String get invocation => 'flutter-architect endpoint <name> [options]';

  EndpointCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Custom endpoint path (e.g. /v1/users). Defaults to /<name>.',
    );
  }

  @override
  Future<int> run() async {
    final endpointName = requireNameArg(label: 'endpoint_name');
    final camel = NamingUtils.toCamelCase(endpointName);
    final snake = NamingUtils.toSnakeCase(endpointName);
    final customPath = argResults?['path'] as String? ?? '/$snake';

    final targetFile = File(p.join(
        projectDir.path, 'lib', 'core', 'network', 'api_endpoints.dart'));

    if (!targetFile.existsSync()) {
      logger.warning('api_endpoints.dart does not exist. Creating it...');
      targetFile.parent.createSync(recursive: true);
      targetFile.writeAsStringSync('''
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com/v1';

  static const String $camel = '$customPath';
}
''');
      logger.success(
          'Created lib/core/network/api_endpoints.dart with endpoint $camel');
      return ExitCodes.success;
    }

    final content = targetFile.readAsStringSync();
    if (content.contains('static const String $camel')) {
      logger.warning(
          'Endpoint "$camel" is already defined in api_endpoints.dart');
      return ExitCodes.success;
    }

    // Insert before closing bracket
    final lastBraceIndex = content.lastIndexOf('}');
    if (lastBraceIndex != -1) {
      final updated = '${content.substring(0, lastBraceIndex)}'
          '  static const String $camel = \'$customPath\';\n'
          '${content.substring(lastBraceIndex)}';

      if (dryRun) {
        logger.dryRun(
            'Would append endpoint: static const String $camel = \'$customPath\';');
      } else {
        targetFile.writeAsStringSync(updated);
        logger.success(
            'Added endpoint "$camel" to lib/core/network/api_endpoints.dart');
      }
    }

    return ExitCodes.success;
  }
}
