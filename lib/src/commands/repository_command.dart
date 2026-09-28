import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/repository_generator.dart';

/// Generates repository interface (domain) and implementation (data).
class RepositoryCommand extends BaseCommand {
  @override
  final String name = 'repository';

  @override
  final String description =
      'Generate a domain repository contract and data repository implementation.';

  @override
  String get invocation => 'flutter-architect repository <name> [options]';

  RepositoryCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help: 'Target feature folder name.',
    );
  }

  @override
  Future<int> run() async {
    final repoName = requireNameArg(label: 'repository_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Repository: $repoName');

    final generator = RepositoryGenerator(
      name: repoName,
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
        'Repository "$repoName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
