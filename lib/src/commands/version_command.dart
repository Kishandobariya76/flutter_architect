import '../cli/base_command.dart';
import '../cli/exit_codes.dart';

const String kPackageVersion = '1.0.1';

/// Displays package version.
class VersionCommand extends BaseCommand {
  @override
  final String name = 'version';

  @override
  final String description =
      'Print the current flutter_architecture_kit CLI version.';

  @override
  String get invocation => 'flutter-architect version';

  VersionCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.info('flutter_architecture_kit version $kPackageVersion');
    return ExitCodes.success;
  }
}
