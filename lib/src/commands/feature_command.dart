import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/feature_generator.dart';

/// Generates a complete Clean Architecture feature directory and code files.
class FeatureCommand extends BaseCommand {
  @override
  final String name = 'feature';

  @override
  final String description =
      'Generate a complete Clean Architecture feature (data, domain, presentation).';

  @override
  String get invocation => 'flutter-architect feature <name> [options]';

  FeatureCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    final featureName = requireNameArg(label: 'feature_name');

    logger.step('Generating feature: $featureName');

    final generator = FeatureGenerator(
      featureName: featureName,
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
        'Feature "$featureName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
