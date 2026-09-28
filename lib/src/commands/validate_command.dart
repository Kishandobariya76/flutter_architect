import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../validation/architecture_validator.dart';

/// Validates Clean Architecture rules, boundary constraints, and folder conventions.
class ValidateCommand extends BaseCommand {
  @override
  final String name = 'validate';

  @override
  final String description =
      'Verify project architecture layers, naming conventions, and integrity.';

  @override
  String get invocation => 'flutter-architect validate';

  ValidateCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    logger.info('');
    logger.title('Flutter Architect Validator');
    logger.info('Inspecting project architecture rules and boundaries...');
    logger.info('');

    final validator = ArchitectureValidator(projectDir);
    final result = validator.validate();

    if (result.isValid) {
      if (result.warningCount > 0) {
        logger.warning(
            'Architecture validation passed with ${result.warningCount} warning(s):');
        for (final issue in result.issues) {
          logger.detail('⚠ ${issue.message}');
          if (issue.fixHint != null) logger.detail('   Fix: ${issue.fixHint}');
        }
      } else {
        logger.success('Architecture validation passed.');
        logger.info('No architectural problems found.');
      }
      return ExitCodes.success;
    }

    logger.error('Architecture validation failed.');
    logger.info(
        '${result.errorCount} error(s) and ${result.warningCount} warning(s) found:');
    logger.info('');

    for (final issue in result.issues) {
      if (issue.isError) {
        logger.error(issue.message);
      } else {
        logger.warning(issue.message);
      }
      if (issue.path != null) logger.detail('Location: ${issue.path}');
      if (issue.fixHint != null) logger.detail('Suggestion: ${issue.fixHint}');
      logger.info('');
    }

    return ExitCodes.dataError;
  }
}
