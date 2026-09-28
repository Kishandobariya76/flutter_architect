import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/cubit_generator.dart';

/// Generates Cubit files (Cubit, State).
class CubitCommand extends BaseCommand {
  @override
  final String name = 'cubit';

  @override
  final String description =
      'Generate modern Cubit state management files (Cubit, State).';

  @override
  String get invocation => 'flutter-architect cubit <name> [options]';

  CubitCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help:
          'Target feature folder name (places cubit in lib/features/<feature>/presentation/cubit).',
    );
  }

  @override
  Future<int> run() async {
    final cubitName = requireNameArg(label: 'cubit_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Cubit: $cubitName');

    final generator = CubitGenerator(
      name: cubitName,
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
        .success('Cubit "$cubitName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
