import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/bottomsheet_generator.dart';

/// Generates Material 3 modal bottom sheets.
class BottomSheetCommand extends BaseCommand {
  @override
  final String name = 'bottomsheet';

  @override
  final String description = 'Generate a Material 3 modal bottom sheet widget.';

  @override
  String get invocation => 'flutter-architect bottomsheet <name> [options]';

  BottomSheetCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help: 'Target feature folder name.',
    );
  }

  @override
  Future<int> run() async {
    final sheetName = requireNameArg(label: 'bottomsheet_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating BottomSheet: $sheetName');

    final generator = BottomSheetGenerator(
      name: sheetName,
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
        'BottomSheet "$sheetName" generated with ${results.length} file.');
    return ExitCodes.success;
  }
}
