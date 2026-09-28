import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/model_generator.dart';

/// Generates typed models with JSON serialization.
class ModelCommand extends BaseCommand {
  @override
  final String name = 'model';

  @override
  final String description =
      'Generate a typed data model with JSON serialization and copyWith.';

  @override
  String get invocation => 'flutter-architect model <name> [options]';

  ModelCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help:
          'Target feature folder name (places model in lib/features/<feature>/data/models).',
    );
  }

  @override
  Future<int> run() async {
    final modelName = requireNameArg(label: 'model_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Model: $modelName');

    final generator = ModelGenerator(
      name: modelName,
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
    logger
        .success('Model "$modelName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
