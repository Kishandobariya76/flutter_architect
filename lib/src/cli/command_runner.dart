import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../commands/api_command.dart';
import '../commands/bloc_command.dart';
import '../commands/bottomsheet_command.dart';
import '../commands/configure_command.dart';
import '../commands/cubit_command.dart';
import '../commands/datasource_command.dart';
import '../commands/dialog_command.dart';
import '../commands/doctor_command.dart';
import '../commands/endpoint_command.dart';
import '../commands/feature_command.dart';
import '../commands/firebase_command.dart';
import '../commands/flavors_command.dart';
import '../commands/init_command.dart';
import '../commands/localization_command.dart';
import '../commands/model_command.dart';
import '../commands/module_command.dart';
import '../commands/page_command.dart';
import '../commands/repository_command.dart';
import '../commands/theme_command.dart';
import '../commands/usecase_command.dart';
import '../commands/validate_command.dart';
import '../commands/version_command.dart';
import '../commands/widget_command.dart';
import 'exit_codes.dart';
import 'logger.dart';
import 'prompts.dart';

/// Top-level command runner for flutter_architect CLI.
class FlutterArchitectCommandRunner extends CommandRunner<int> {
  final Logger logger;
  final Prompts prompts;
  final Directory projectDir;

  FlutterArchitectCommandRunner({
    Logger? customLogger,
    Prompts? customPrompts,
    Directory? customProjectDir,
  })  : logger = customLogger ?? Logger(),
        prompts = customPrompts ?? Prompts(),
        projectDir = customProjectDir ?? Directory.current,
        super(
          'flutter-architect',
          'Production-Ready Flutter Architecture CLI for Clean Architecture, BLoC, and scaffolding.',
        ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current flutter_architect version.',
    );
    argParser.addFlag(
      'no-color',
      negatable: false,
      help: 'Disable ANSI color formatting in terminal output.',
    );

    // Register all V1.0 commands
    addCommand(
        InitCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(ConfigureCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(DoctorCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(ValidateCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(VersionCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(FeatureCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(ModuleCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        BlocCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        CubitCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        ModelCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(RepositoryCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(DatasourceCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(UsecaseCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        PageCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(WidgetCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(DialogCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(BottomSheetCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        ApiCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(EndpointCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(
        ThemeCommand(logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(LocalizationCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(FlavorsCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
    addCommand(FirebaseCommand(
        logger: logger, prompts: prompts, projectDir: projectDir));
  }

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);
      return await runCommand(topLevelResults) ?? ExitCodes.success;
    } on FormatException catch (e) {
      logger.error(e.message);
      logger.info(
          'Run "flutter-architect --help" for available commands and usage.');
      return ExitCodes.usage;
    } on UsageException catch (e) {
      logger.error(e.message);
      logger.info('');
      logger.info(e.usage);
      return ExitCodes.usage;
    } catch (e, stack) {
      logger.error('Unexpected error: $e');
      if (Platform.environment['FLUTTER_ARCHITECT_DEBUG'] == 'true') {
        logger.detail(stack.toString());
      }
      return ExitCodes.software;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] == true) {
      logger.info('flutter_architect version $kPackageVersion');
      return ExitCodes.success;
    }
    return super.runCommand(topLevelResults);
  }
}
