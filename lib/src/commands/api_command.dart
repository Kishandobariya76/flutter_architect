import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/api_generator.dart';

/// Generates a full API integration slice (remote datasource, model, repository, usecase, bloc).
class ApiCommand extends BaseCommand {
  @override
  final String name = 'api';

  @override
  final String description =
      'Generate a complete API integration slice with HTTP method configuration.';

  @override
  String get invocation => 'flutter-architect api <name> [options]';

  ApiCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'method',
      abbr: 'm',
      help: 'HTTP request method.',
      allowed: ['get', 'post', 'put', 'patch', 'delete'],
      defaultsTo: 'get',
    );
  }

  @override
  Future<int> run() async {
    final apiName = requireNameArg(label: 'api_name');
    final method = (argResults?['method'] as String?) ?? 'get';

    logger
        .step('Generating API slice for "$apiName" [${method.toUpperCase()}]');

    final generator = ApiGenerator(
      name: apiName,
      method: method,
      fileManager: fileManager,
      config: projectConfig,
      projectDir: projectDir,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );

    final results = await generator.generate();

    logger.info('');
    logger.success(
        'API slice "$apiName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
