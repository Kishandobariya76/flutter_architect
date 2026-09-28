import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/dialog_generator.dart';

/// Generates Material 3 dialog components.
class DialogCommand extends BaseCommand {
  @override
  final String name = 'dialog';

  @override
  final String description = 'Generate a Material 3 dialog component.';

  @override
  String get invocation => 'flutter-architect dialog <name> [options]';

  DialogCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help: 'Target feature folder name.',
    );
  }

  @override
  Future<int> run() async {
    final dialogName = requireNameArg(label: 'dialog_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Dialog: $dialogName');

    final generator = DialogGenerator(
      name: dialogName,
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
        .success('Dialog "$dialogName" generated with ${results.length} file.');
    return ExitCodes.success;
  }
}
