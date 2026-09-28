import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/page_generator.dart';

/// Generates Material 3 pages.
class PageCommand extends BaseCommand {
  @override
  final String name = 'page';

  @override
  final String description = 'Generate a Material 3 responsive Flutter page.';

  @override
  String get invocation => 'flutter-architect page <name> [options]';

  PageCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help:
          'Target feature folder name (places page in lib/features/<feature>/presentation/pages).',
    );
  }

  @override
  Future<int> run() async {
    final pageName = requireNameArg(label: 'page_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Page: $pageName');

    final generator = PageGenerator(
      name: pageName,
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
    logger.success('Page "$pageName" generated with ${results.length} file.');
    return ExitCodes.success;
  }
}
