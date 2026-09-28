import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/widget_generator.dart';

/// Generates reusable Flutter UI widgets.
class WidgetCommand extends BaseCommand {
  @override
  final String name = 'widget';

  @override
  final String description =
      'Generate a theme-aware reusable Flutter UI widget.';

  @override
  String get invocation => 'flutter-architect widget <name> [options]';

  WidgetCommand({super.logger, super.prompts, super.projectDir}) {
    argParser.addOption(
      'feature',
      abbr: 'm',
      help:
          'Target feature folder name (places widget in lib/features/<feature>/presentation/widgets).',
    );
  }

  @override
  Future<int> run() async {
    final widgetName = requireNameArg(label: 'widget_name');
    final feature = argResults?['feature'] as String?;

    logger.step('Generating Widget: $widgetName');

    final generator = WidgetGenerator(
      name: widgetName,
      featureName: feature,
      fileManager: fileManager,
      config: projectConfig,
      projectDir: projectDir,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );

    final results = await generator.generate();

    logger.info('');
    logger
        .success('Widget "$widgetName" generated with ${results.length} file.');
    return ExitCodes.success;
  }
}
