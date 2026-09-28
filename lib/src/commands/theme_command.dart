import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/theme_generator.dart';

/// Scaffolds or updates the Material 3 theme layer.
class ThemeCommand extends BaseCommand {
  @override
  final String name = 'theme';

  @override
  final String description =
      'Generate or update Material 3 theme tokens, typography, and light/dark modes.';

  @override
  String get invocation => 'flutter-architect theme [options]';

  ThemeCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.step('Generating Material 3 theme architecture...');

    final generator = ThemeGenerator(
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
        .success('Theme architecture generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
