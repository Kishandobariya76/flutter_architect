import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/localization_generator.dart';

/// Scaffolds Flutter localization setup (l10n.yaml, English and Spanish ARB files).
class LocalizationCommand extends BaseCommand {
  @override
  final String name = 'localization';

  @override
  final String description =
      'Generate Flutter localization configuration and ARB translation templates.';

  @override
  String get invocation => 'flutter-architect localization [options]';

  LocalizationCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.step('Generating Flutter localization scaffolding...');

    final generator = LocalizationGenerator(
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
        .success('Localization setup generated with ${results.length} files.');
    logger.info(
        'Next step: Add "flutter_localizations" to pubspec.yaml dependencies.');
    return ExitCodes.success;
  }
}
