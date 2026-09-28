import '../cli/base_command.dart';
import '../cli/exit_codes.dart';

const String kPackageVersion = '3.0.0';

/// Displays package version.
class VersionCommand extends BaseCommand {
  @override
  final String name = 'version';

  @override
  final String description = 'Print the current flutter_architect CLI version.';

  @override
  String get invocation => 'flutter-architect version';

  VersionCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.info('flutter_architect version $kPackageVersion');
    return ExitCodes.success;
  }
}
