import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../doctor/doctor_check.dart';
import '../doctor/doctor_runner.dart';

/// Runs environment and project diagnostics.
class DoctorCommand extends BaseCommand {
  @override
  final String name = 'doctor';

  @override
  final String description =
      'Inspect Flutter & Dart toolchains, dependencies, and architecture setup.';

  @override
  String get invocation => 'flutter-architect doctor';

  DoctorCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    final runner = DoctorRunner(logger: logger, projectDir: projectDir);
    final checks = await runner.runChecks();
    runner.printResults(checks);

    final hasFailures = checks.any((c) => c.status == CheckStatus.failed);
    return hasFailures ? ExitCodes.unavailable : ExitCodes.success;
  }
}
