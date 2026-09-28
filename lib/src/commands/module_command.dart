import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/feature_generator.dart';

/// Generates an isolated modular architecture package/module.
class ModuleCommand extends BaseCommand {
  @override
  final String name = 'module';

  @override
  final String description =
      'Generate an isolated architectural module structure.';

  @override
  String get invocation => 'flutter-architect module <name> [options]';

  ModuleCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    final moduleName = requireNameArg(label: 'module_name');

    logger.step('Generating module: $moduleName');

    final generator = FeatureGenerator(
      featureName: moduleName,
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
        'Module "$moduleName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
