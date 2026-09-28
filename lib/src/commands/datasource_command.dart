import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/datasource_generator.dart';

/// Generates Remote and Local data sources.
class DatasourceCommand extends BaseCommand {
  @override
  final String name = 'datasource';

  @override
  final String description =
      'Generate remote and local data source implementations.';

  @override
  String get invocation => 'flutter-architect datasource <name> [options]';

  DatasourceCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help: 'Target feature folder name.',
    );
  }

  @override
  Future<int> run() async {
    final dsName = requireNameArg(label: 'datasource_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Datasources: $dsName');

    final generator = DatasourceGenerator(
      name: dsName,
      featureName: feature,
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
        'Datasources for "$dsName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
