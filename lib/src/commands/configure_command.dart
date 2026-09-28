import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../configuration/config_resolver.dart';
import '../configuration/project_config.dart';

/// Configures existing project settings in flutter_architect.yaml.
class ConfigureCommand extends BaseCommand {
  @override
  final String name = 'configure';

  @override
  final String description =
      'Inspect or update project architecture settings in flutter_architect.yaml.';

  @override
  String get invocation => 'flutter-architect configure [options]';

  ConfigureCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'state-management',
      abbr: 's',
      help: 'Update state management library.',
      allowed: ['bloc', 'cubit', 'none'],
    );
    argParser.addOption(
      'network',
      abbr: 'n',
      help: 'Update networking client.',
      allowed: ['dio', 'none'],
    );
    argParser.addOption(
      'di',
      abbr: 'd',
      help: 'Update dependency injection mechanism.',
      allowed: ['get_it', 'none'],
    );
    argParser.addFlag(
      'show',
      help: 'Display current configuration settings.',
      negatable: false,
    );
  }

  @override
  Future<int> run() async {
    final currentConfig = ConfigResolver.loadConfig(projectDir);

    if (argResults?['show'] == true) {
      logger.info('');
      logger.title('Current Project Configuration');
      logger.info(currentConfig.toYamlString());
      return ExitCodes.success;
    }

    var state =
        argResults?['state-management'] ?? currentConfig.stateManagement.value;
    var net = argResults?['network'] ?? currentConfig.networking.value;
    var di = argResults?['di'] ?? currentConfig.dependencyInjection.value;

    if (prompts.isInteractive && !argResults!.wasParsed('state-management')) {
      state = prompts.select(
        prompt: 'Select state management',
        options: ['bloc', 'cubit', 'none'],
        defaultValue: currentConfig.stateManagement.value,
      );

      net = prompts.select(
        prompt: 'Select networking client',
        options: ['dio', 'none'],
        defaultValue: currentConfig.networking.value,
      );

      di = prompts.select(
        prompt: 'Select dependency injection',
        options: ['get_it', 'none'],
        defaultValue: currentConfig.dependencyInjection.value,
      );
    }

    final updated = currentConfig.copyWith(
      stateManagement: StateManagementType.fromString(state),
      networking: NetworkingType.fromString(net),
      dependencyInjection: DependencyInjectionType.fromString(di),
    );

    ConfigResolver.saveConfig(updated, projectDir);
    logger.success('Configuration saved to flutter_architect.yaml');
    return ExitCodes.success;
  }
}
