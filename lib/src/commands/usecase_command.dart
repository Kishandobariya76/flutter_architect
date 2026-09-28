import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/usecase_generator.dart';

/// Generates domain use case classes.
class UsecaseCommand extends BaseCommand {
  @override
  final String name = 'usecase';

  @override
  final String description = 'Generate a Clean Architecture domain usecase.';

  @override
  String get invocation => 'flutter-architect usecase <name> [options]';

  UsecaseCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help: 'Target feature folder name.',
    );
  }

  @override
  Future<int> run() async {
    final usecaseName = requireNameArg(label: 'usecase_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating UseCase: $usecaseName');

    final generator = UsecaseGenerator(
      name: usecaseName,
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
        'UseCase "$usecaseName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
