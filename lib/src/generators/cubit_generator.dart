import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates Cubit files (Cubit, State).
class CubitGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  CubitGenerator({
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
        ? 'lib/features/$featSnake/presentation/cubit'
        : 'lib/presentation/cubit/$snake';

    results.add(renderAndWrite(
      relativePath: '$dirPath/${snake}_state.dart',
      templateName:
          isFeature ? 'feature_bloc_state.dart' : 'standalone_bloc_state.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureBlocState
          : TemplateRegistry.standaloneBlocState,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$dirPath/${snake}_cubit.dart',
      templateName: isFeature ? 'feature_cubit.dart' : 'standalone_cubit.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureCubit
          : TemplateRegistry.standaloneCubit,
      context: context,
    ));

    return results;
  }
}
