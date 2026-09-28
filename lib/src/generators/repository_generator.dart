import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates repository contract in domain and implementation in data.
class RepositoryGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  RepositoryGenerator({
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
    final results = <FileGenerationResult>[];

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

    final domainPath = isFeature
        ? 'lib/features/$featSnake/domain/repositories'
        : 'lib/domain/repositories';

    final dataPath = isFeature
        ? 'lib/features/$featSnake/data/repositories'
        : 'lib/data/repositories';

    // 1. Interface
    results.add(renderAndWrite(
      relativePath: '$domainPath/${snake}_repository.dart',
      templateName:
          isFeature ? 'feature_repository.dart' : 'standalone_repository.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureRepository
          : TemplateRegistry.standaloneRepository,
      context: context,
    ));

    // 2. Implementation
    results.add(renderAndWrite(
      relativePath: '$dataPath/${snake}_repository_impl.dart',
      templateName: isFeature
          ? 'feature_repository_impl.dart'
          : 'standalone_repository_impl.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureRepositoryImpl
          : TemplateRegistry.standaloneRepositoryImpl,
      context: context,
    ));

    return results;
  }
}
