import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates modern BLoC files (Bloc, Event, State).
class BlocGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  BlocGenerator({
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
        ? 'lib/features/$featSnake/presentation/bloc'
        : 'lib/presentation/bloc/$snake';

    results.add(renderAndWrite(
      relativePath: '$dirPath/${snake}_event.dart',
      templateName:
          isFeature ? 'feature_bloc_event.dart' : 'standalone_bloc_event.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureBlocEvent
          : TemplateRegistry.standaloneBlocEvent,
      context: context,
    ));

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
      relativePath: '$dirPath/${snake}_bloc.dart',
      templateName: isFeature ? 'feature_bloc.dart' : 'standalone_bloc.dart',
      defaultContent: isFeature
          ? TemplateRegistry.featureBloc
          : TemplateRegistry.standaloneBloc,
      context: context,
    ));

    return results;
  }
}
