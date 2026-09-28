import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates domain use cases.
class UsecaseGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  UsecaseGenerator({
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

    final isFeature = featureName != null;
    final featSnake = isFeature ? NamingUtils.toSnakeCase(featureName!) : snake;

    final context = {
      'name': snake,
      'name_pascal': pascal,
      'name_camel': camel,
      'name_title': title,
      'feature_name': featSnake,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'feature_title': title,
    };

    final dirPath = isFeature
        ? 'lib/features/$featSnake/domain/usecases'
        : 'lib/domain/usecases';

    final result = renderAndWrite(
      relativePath: '$dirPath/get_${snake}_usecase.dart',
      templateName:
          isFeature ? 'feature_usecase.dart' : 'standalone_usecase.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureUseCase
          : TemplateRegistry.standaloneUseCase,
      context: context,
    );

    return [result];
  }
}
