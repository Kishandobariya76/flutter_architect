import 'dart:io';
import 'package:args/command_runner.dart';
import '../configuration/config_resolver.dart';
import '../configuration/project_config.dart';
import '../filesystem/file_manager.dart';
import 'exit_codes.dart';
import 'logger.dart';
import 'prompts.dart';

/// Base class for all flutter-architect CLI commands.
abstract class BaseCommand extends Command<int> {
  final Logger logger;
  final Prompts prompts;
  final Directory projectDir;

  BaseCommand({
    Logger? logger,
    Prompts? prompts,
    Directory? projectDir,
  })  : logger = logger ?? Logger(),
        prompts = prompts ?? Prompts(),
        projectDir = projectDir ?? Directory.current {
    argParser.addFlag(
      'dry-run',
      help: 'Simulate file generation without writing changes to disk.',
      negatable: false,
    );
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Force overwrite existing files without confirmation prompts.',
      negatable: false,
    );
    argParser.addFlag(
      'skip-existing',
      help: 'Skip files that already exist without prompting.',
      negatable: false,
    );
  }

  bool get dryRun => argResults?['dry-run'] == true;
  bool get force => argResults?['force'] == true;
  bool get skipExisting => argResults?['skip-existing'] == true;

  FileManager get fileManager => FileManager(
        logger: logger,
        prompts: prompts,
        baseDir: projectDir,
      );

  ProjectConfig get projectConfig => ConfigResolver.loadConfig(projectDir);

  /// Helper to require a name argument for generator commands.
  String requireNameArg({String label = 'name'}) {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      logger.error('Missing required argument <$label>.');
      logger.info('Usage: $invocation');
      exit(ExitCodes.usage);
    }
    return rest.first;
  }
}
