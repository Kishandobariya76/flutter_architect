import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates reusable Flutter UI widgets.
class WidgetGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  WidgetGenerator({
    required this.name,
    this.featureName,
    required super.fileManager,
    required super.config,
    super.projectDir,
    super.dryRun,
    super.force,
    super.skipExisting,
  });

  @override
  Future<List<FileGenerationResult>> generate() async {
    final snake = NamingUtils.toSnakeCase(name);
    final pascal = NamingUtils.toPascalCase(name);
    final camel = NamingUtils.toCamelCase(name);
    final title = NamingUtils.toTitleCase(name);

    final context = {
      'name': snake,
      'name_pascal': pascal,
      'name_camel': camel,
      'name_title': title,
    };

    final dirPath = featureName != null
        ? 'lib/features/${NamingUtils.toSnakeCase(featureName!)}/presentation/widgets'
        : 'lib/presentation/widgets';

    final result = renderAndWrite(
      relativePath: '$dirPath/${snake}_widget.dart',
      templateName: 'standalone_widget.dart',
      defaultContent: TemplateRegistry.standaloneWidget,
      context: context,
    );

    return [result];
  }
}
