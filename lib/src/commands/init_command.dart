import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../configuration/config_resolver.dart';
import '../configuration/project_config.dart';
import '../generators/core_generator.dart';
import '../generators/feature_generator.dart';
import '../utils/pubspec_utils.dart';

/// Initializes a production-grade Flutter architecture.
class InitCommand extends BaseCommand {
  @override
  final String name = 'init';

  @override
  final String description =
      'Initialize production-ready Clean Architecture in a Flutter project.';

  @override
  String get invocation => 'flutter-architect init [options]';

  InitCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'architecture',
      abbr: 'a',
      help: 'Target architecture style.',
      allowed: ['clean', 'feature_first'],
      defaultsTo: 'clean',
    );
    argParser.addOption(
      'state-management',
      abbr: 's',
      help: 'Primary state management library.',
      allowed: ['bloc', 'cubit', 'none'],
      defaultsTo: 'bloc',
    );
    argParser.addOption(
      'network',
      abbr: 'n',
      help: 'Networking HTTP client.',
      allowed: ['dio', 'none'],
      defaultsTo: 'dio',
    );
    argParser.addOption(
      'di',
      abbr: 'd',
      help: 'Dependency injection approach.',
      allowed: ['get_it', 'none'],
      defaultsTo: 'get_it',
    );
    argParser.addOption(
      'theme',
      abbr: 't',
      help: 'Theming configuration.',
      allowed: ['material3', 'standard'],
      defaultsTo: 'material3',
    );
    argParser.addFlag(
      'example-feature',
      help: 'Generate an example Clean Architecture feature (e.g. auth/login).',
      defaultsTo: true,
    );
  }

  @override
  Future<int> run() async {
    logger.info('');
    logger.title('Flutter Architect');
    logger.info('Initializing production Clean Architecture scaffolding...');
    logger.info('');

    // Warn if not inside a Flutter project
    if (!PubspecUtils.isFlutterProject(projectDir)) {
      logger.warning(
          'Notice: Current directory does not look like a Flutter project.');
      logger.info('Proceeding with scaffolding in ${projectDir.path}...');
      logger.info('');
    }

    String chosenArch = argResults?['architecture'] ?? 'clean';
    String chosenState = argResults?['state-management'] ?? 'bloc';
    String chosenNetwork = argResults?['network'] ?? 'dio';
    String chosenDi = argResults?['di'] ?? 'get_it';
    String chosenTheme = argResults?['theme'] ?? 'material3';
    bool generateExample = argResults?['example-feature'] ?? true;

    // If terminal is interactive and no explicit flags passed, prompt interactively
    if (prompts.isInteractive && !argResults!.wasParsed('architecture')) {
      chosenArch = prompts.select(
                prompt: 'Project architecture',
                options: ['Clean Architecture', 'Feature-first'],
                defaultValue: 'Clean Architecture',
              ) ==
              'Clean Architecture'
          ? 'clean'
          : 'feature_first';

      chosenState = prompts
          .select(
            prompt: 'State management',
            options: ['BLoC', 'Cubit', 'None'],
            defaultValue: 'BLoC',
          )
          .toLowerCase();

      chosenNetwork = prompts
          .select(
            prompt: 'Networking',
            options: ['Dio', 'None'],
            defaultValue: 'Dio',
          )
          .toLowerCase();

      chosenDi = prompts
          .select(
            prompt: 'Dependency injection',
            options: ['GetIt', 'None'],
            defaultValue: 'GetIt',
          )
          .toLowerCase()
          .replaceAll('getit', 'get_it');

      chosenTheme = prompts
              .select(
                prompt: 'Theme',
                options: ['Material 3 + Light/Dark', 'Standard'],
                defaultValue: 'Material 3 + Light/Dark',
              )
              .startsWith('Material 3')
          ? 'material3'
          : 'standard';

      generateExample = prompts.confirm(
        prompt: 'Generate example feature (auth)?',
        defaultValue: true,
      );
    }

    final config = ProjectConfig(
      architecture: ArchitectureType.fromString(chosenArch),
      stateManagement: StateManagementType.fromString(chosenState),
      networking: NetworkingType.fromString(chosenNetwork),
      dependencyInjection: DependencyInjectionType.fromString(chosenDi),
      theme: ThemeType.fromString(chosenTheme),
      generateEntities: false,
    );

    // Save configuration file
    if (!dryRun) {
      ConfigResolver.saveConfig(config, projectDir);
      logger.success('Saved configuration to flutter_architect.yaml');
    } else {
      logger.dryRun('Would create flutter_architect.yaml');
    }

    logger.step('Creating Flutter architecture...');

    // Generate core
    final coreGen = CoreGenerator(
      fileManager: fileManager,
      config: config,
      projectDir: projectDir,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );
    await coreGen.generate();

    // Generate example feature if requested
    if (generateExample) {
      final featGen = FeatureGenerator(
        featureName: 'auth',
        fileManager: fileManager,
        config: config,
        projectDir: projectDir,
        dryRun: dryRun,
        force: force,
        skipExisting: skipExisting,
      );
      await featGen.generate();
    }

    logger.info('');
    logger.success('Flutter Architect project initialized successfully.');
    logger.info('');
    logger.info('Next steps:');
    logger
        .info('  1. Add dependencies: flutter pub add flutter_bloc dio get_it');
    logger.info('  2. Run doctor check: flutter-architect doctor');
    logger.info('  3. Generate features: flutter-architect feature <name>');
    logger.info('');

    return ExitCodes.success;
  }
}
