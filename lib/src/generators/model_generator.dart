import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates strongly typed data models with JSON serialization.
class ModelGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  ModelGenerator({
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

    final featSnake =
        featureName != null ? NamingUtils.toSnakeCase(featureName!) : snake;

    final context = {
      'feature_name': featSnake,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'feature_title': title,
    };

    final dirPath = featureName != null
        ? 'lib/features/$featSnake/data/models'
        : 'lib/data/models';

    final result = renderAndWrite(
      relativePath: '$dirPath/${snake}_model.dart',
      templateName: 'feature_model.dart',
      defaultContent: TemplateRegistry.featureModel,
      context: context,
    );

    return [result];
  }
}
