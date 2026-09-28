import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/flavors_generator.dart';

/// Scaffolds build flavor configuration (development, staging, production).
class FlavorsCommand extends BaseCommand {
  @override
  final String name = 'flavors';

  @override
  final String description =
      'Generate development, staging, and production flavors with dedicated entrypoints.';

  @override
  String get invocation => 'flutter-architect flavors [options]';

  FlavorsCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.step('Generating multi-flavor architecture...');

    final generator = FlavorsGenerator(
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
        'Flavor configuration generated with ${results.length} files.');
    logger.info('Run configurations:');
    logger.info(
        '  Development: flutter run -t lib/main_development.dart --flavor development');
    logger.info(
        '  Staging:     flutter run -t lib/main_staging.dart --flavor staging');
    logger.info(
        '  Production:  flutter run -t lib/main_production.dart --flavor production');
    return ExitCodes.success;
  }
}
