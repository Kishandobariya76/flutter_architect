import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates Remote and Local data sources.
class DatasourceGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  DatasourceGenerator({
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

    final dirPath = isFeature
        ? 'lib/features/$featSnake/data/datasources'
        : 'lib/data/datasources';

    results.add(renderAndWrite(
      relativePath: '$dirPath/${snake}_remote_datasource.dart',
      templateName: isFeature
          ? 'feature_remote_datasource.dart'
          : 'standalone_datasource_remote.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureRemoteDatasource
          : TemplateRegistry.standaloneDatasourceRemote,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$dirPath/${snake}_local_datasource.dart',
      templateName: isFeature
          ? 'feature_local_datasource.dart'
          : 'standalone_datasource_local.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureLocalDatasource
          : TemplateRegistry.standaloneDatasourceLocal,
      context: context,
    ));

    return results;
  }
}
