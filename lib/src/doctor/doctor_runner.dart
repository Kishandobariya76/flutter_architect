import 'dart:io';
import '../cli/logger.dart';
import '../configuration/config_resolver.dart';
import '../configuration/project_config.dart';
import '../utils/platform_utils.dart';
import '../utils/pubspec_utils.dart';
import 'doctor_check.dart';

/// Runs diagnostic health checks on the environment and current Flutter project.
class DoctorRunner {
  final Logger logger;
  final Directory projectDir;

  DoctorRunner({
    Logger? logger,
    Directory? projectDir,
  })  : logger = logger ?? Logger(),
        projectDir = projectDir ?? Directory.current;

  Future<List<DoctorCheck>> runChecks() async {
    final checks = <DoctorCheck>[];

    // 1. Dart installation check
    final dartAvailable = await PlatformUtils.isCommandAvailable('dart');
    if (dartAvailable) {
      final dartVersion = await PlatformUtils.runProcess('dart', ['--version']);
      checks.add(DoctorCheck(
        title: 'Dart installed',
        status: CheckStatus.passed,
        details: dartVersion?.split('\n').first,
      ));
    } else {
      checks.add(const DoctorCheck(
        title: 'Dart installed',
        status: CheckStatus.failed,
        resolution: 'Install the Dart SDK or add it to your system PATH.',
      ));
    }

    // 2. Flutter installation check
    final flutterAvailable =
        await PlatformUtils.isCommandAvailable(PlatformUtils.flutterCommand);
    if (flutterAvailable) {
      final flutterVersion = await PlatformUtils.runProcess(
          PlatformUtils.flutterCommand, ['--version']);
      checks.add(DoctorCheck(
        title: 'Flutter installed',
        status: CheckStatus.passed,
        details: flutterVersion?.split('\n').first,
      ));
    } else {
      checks.add(const DoctorCheck(
        title: 'Flutter installed',
        status: CheckStatus.failed,
        resolution:
            'Install Flutter from https://flutter.dev and add it to your PATH.',
      ));
    }

    // 3. Flutter project detection
    final isFlutter = PubspecUtils.isFlutterProject(projectDir);
    if (isFlutter) {
      checks.add(const DoctorCheck(
        title: 'Flutter project detected',
        status: CheckStatus.passed,
      ));
    } else {
      checks.add(const DoctorCheck(
        title: 'Flutter project detected',
        status: CheckStatus.warning,
        details: 'Current directory is not recognized as a Flutter project.',
        resolution:
            'Run inside a Flutter project or create one with "flutter create <app_name>".',
      ));
    }

    // 4. pubspec.yaml detection
    final pubspecFile = PubspecUtils.findPubspec(projectDir);
    if (pubspecFile != null) {
      checks.add(DoctorCheck(
        title: 'pubspec.yaml detected',
        status: CheckStatus.passed,
        details: pubspecFile.path,
      ));
    } else {
      checks.add(const DoctorCheck(
        title: 'pubspec.yaml detected',
        status: CheckStatus.failed,
        resolution:
            'Ensure you are running inside a Dart/Flutter project directory.',
      ));
    }

    // 5. Configuration file check
    final configFile = ConfigResolver.findConfigFile(projectDir);
    if (configFile != null) {
      checks.add(DoctorCheck(
        title: 'Architecture configuration valid',
        status: CheckStatus.passed,
        details: configFile.path,
      ));
    } else {
      checks.add(const DoctorCheck(
        title: 'Architecture configuration found',
        status: CheckStatus.warning,
        details: 'flutter_architect.yaml is not present.',
        resolution:
            'Run "flutter-architect init" to initialize the project architecture.',
      ));
    }

    // 6. Check required dependencies based on config
    final config = ConfigResolver.loadConfig(projectDir);

    if (config.stateManagement == StateManagementType.bloc ||
        config.stateManagement == StateManagementType.cubit) {
      final hasBloc = PubspecUtils.hasDependency('flutter_bloc', projectDir);
      checks.add(DoctorCheck(
        title: 'flutter_bloc dependency detected',
        status: hasBloc ? CheckStatus.passed : CheckStatus.warning,
        resolution: hasBloc ? null : 'Run: flutter pub add flutter_bloc',
      ));
    }

    if (config.networking == NetworkingType.dio) {
      final hasDio = PubspecUtils.hasDependency('dio', projectDir);
      checks.add(DoctorCheck(
        title: 'dio dependency detected',
        status: hasDio ? CheckStatus.passed : CheckStatus.warning,
        resolution: hasDio ? null : 'Run: flutter pub add dio',
      ));
    }

    if (config.dependencyInjection == DependencyInjectionType.getIt) {
      final hasGetIt = PubspecUtils.hasDependency('get_it', projectDir);
      checks.add(DoctorCheck(
        title: 'get_it dependency detected',
        status: hasGetIt ? CheckStatus.passed : CheckStatus.warning,
        resolution: hasGetIt ? null : 'Run: flutter pub add get_it',
      ));
    }

    return checks;
  }

  /// Prints doctor output formatted to terminal.
  void printResults(List<DoctorCheck> checks) {
    logger.info('');
    logger.title('Flutter Architect Doctor');
    logger.info('');

    var failureCount = 0;
    var warningCount = 0;

    for (final check in checks) {
      switch (check.status) {
        case CheckStatus.passed:
          logger.success(check.title);
          if (check.details != null) {
            logger.detail(check.details!);
          }
          break;
        case CheckStatus.warning:
          warningCount++;
          logger.warning(check.title);
          if (check.details != null) logger.detail(check.details!);
          if (check.resolution != null) {
            logger.info('  Suggestion: ${check.resolution!}');
          }
          break;
        case CheckStatus.failed:
          failureCount++;
          logger.error(check.title);
          if (check.details != null) logger.detail(check.details!);
          if (check.resolution != null) {
            logger.info('  Resolution: ${check.resolution!}');
          }
          break;
      }
    }

    logger.info('');
    if (failureCount == 0 && warningCount == 0) {
      logger.success('No problems found. Your environment is ready!');
    } else {
      logger.info(
          'Summary: $failureCount error(s), $warningCount warning(s) found.');
    }
  }
}
