import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/firebase_generator.dart';

/// Scaffolds Firebase service architecture and documents setup.
class FirebaseCommand extends BaseCommand {
  @override
  final String name = 'firebase';

  @override
  final String description =
      'Generate Firebase service wrapper with Crashlytics, Analytics, and Messaging boilerplate.';

  @override
  String get invocation => 'flutter-architect firebase [options]';

  FirebaseCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.step('Generating Firebase service wrapper...');

    final generator = FirebaseGenerator(
      fileManager: fileManager,
      config: projectConfig,
      projectDir: projectDir,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );

    final results = await generator.generate();

    logger.info('');
    logger.success('Firebase service generated with ${results.length} file.');
    logger.info('');
    logger.title('Manual Firebase Setup Checklist:');
    logger.info(
        '  1. Install FlutterFire CLI: dart pub global activate flutterfire_cli');
    logger.info('  2. Configure your project:  flutterfire configure');
    logger.info(
        '  3. Add dependencies:        flutter pub add firebase_core firebase_analytics firebase_crashlytics');
    logger.info(
        '  4. Initialize in main.dart: await FirebaseService.initialize();');
    return ExitCodes.success;
  }
}
