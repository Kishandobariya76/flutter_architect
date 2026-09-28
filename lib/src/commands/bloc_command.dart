import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/bloc_generator.dart';

/// Generates BLoC state management files (Bloc, Event, State).
class BlocCommand extends BaseCommand {
  @override
  final String name = 'bloc';

  @override
  final String description =
      'Generate modern flutter_bloc files (Bloc, Event, State).';

  @override
  String get invocation => 'flutter-architect bloc <name> [options]';

  BlocCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help:
          'Target feature folder name (places bloc in lib/features/<feature>/presentation/bloc).',
    );
  }

  @override
  Future<int> run() async {
    final blocName = requireNameArg(label: 'bloc_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating BLoC: $blocName');

    final generator = BlocGenerator(
      name: blocName,
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
    logger.success('BLoC "$blocName" generated with ${results.length} files.');
    return ExitCodes.success;
  }
}
