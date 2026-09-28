import '../configuration/project_config.dart';
import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates a complete Clean Architecture feature bundle.
class FeatureGenerator extends BaseGenerator {
  final String featureName;

  FeatureGenerator({
    required this.featureName,
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

    final snake = NamingUtils.toSnakeCase(featureName);
    final pascal = NamingUtils.toPascalCase(featureName);
    final camel = NamingUtils.toCamelCase(featureName);
    final title = NamingUtils.toTitleCase(featureName);

    final context = {
      'feature_name': snake,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'feature_title': title,
    };

    final basePath = 'lib/features/$snake';

    // 1. Data layer: Model
    results.add(renderAndWrite(
      relativePath: '$basePath/data/models/${snake}_model.dart',
      templateName: 'feature_model.dart',
      defaultContent: TemplateRegistry.featureModel,
      context: context,
    ));

    // 2. Data layer: DataSources
    results.add(renderAndWrite(
      relativePath:
          '$basePath/data/datasources/${snake}_remote_datasource.dart',
      templateName: 'feature_remote_datasource.dart',
      defaultContent: TemplateRegistry.featureRemoteDatasource,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$basePath/data/datasources/${snake}_local_datasource.dart',
      templateName: 'feature_local_datasource.dart',
      defaultContent: TemplateRegistry.featureLocalDatasource,
      context: context,
    ));

    // 3. Domain layer: Repository interface
    results.add(renderAndWrite(
      relativePath: '$basePath/domain/repositories/${snake}_repository.dart',
      templateName: 'feature_repository.dart',
      defaultContent: TemplateRegistry.featureRepository,
      context: context,
    ));

    // 4. Data layer: Repository implementation
    results.add(renderAndWrite(
      relativePath: '$basePath/data/repositories/${snake}_repository_impl.dart',
      templateName: 'feature_repository_impl.dart',
      defaultContent: TemplateRegistry.featureRepositoryImpl,
      context: context,
    ));

    // 5. Domain layer: UseCase
    results.add(renderAndWrite(
      relativePath: '$basePath/domain/usecases/get_${snake}_usecase.dart',
      templateName: 'feature_usecase.dart',
      defaultContent: TemplateRegistry.featureUseCase,
      context: context,
    ));

    // 6. Presentation layer: State Management (BLoC vs Cubit)
    if (config.stateManagement == StateManagementType.cubit) {
      results.add(renderAndWrite(
        relativePath: '$basePath/presentation/cubit/${snake}_state.dart',
        templateName: 'feature_bloc_state.dart',
        defaultContent: TemplateRegistry.featureBlocState,
        context: context,
      ));

      results.add(renderAndWrite(
        relativePath: '$basePath/presentation/cubit/${snake}_cubit.dart',
        templateName: 'feature_cubit.dart',
        defaultContent: TemplateRegistry.featureCubit,
        context: context,
      ));
    } else {
      results.add(renderAndWrite(
        relativePath: '$basePath/presentation/bloc/${snake}_event.dart',
        templateName: 'feature_bloc_event.dart',
        defaultContent: TemplateRegistry.featureBlocEvent,
        context: context,
      ));

      results.add(renderAndWrite(
        relativePath: '$basePath/presentation/bloc/${snake}_state.dart',
        templateName: 'feature_bloc_state.dart',
        defaultContent: TemplateRegistry.featureBlocState,
        context: context,
      ));

      results.add(renderAndWrite(
        relativePath: '$basePath/presentation/bloc/${snake}_bloc.dart',
        templateName: 'feature_bloc.dart',
        defaultContent: TemplateRegistry.featureBloc,
        context: context,
      ));
    }

    // 7. Presentation layer: Pages & Widgets
    results.add(renderAndWrite(
      relativePath: '$basePath/presentation/pages/${snake}_page.dart',
      templateName: 'feature_page.dart',
      defaultContent: TemplateRegistry.featurePage,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$basePath/presentation/widgets/${snake}_item_view.dart',
      templateName: 'feature_widget.dart',
      defaultContent: TemplateRegistry.featureWidget,
      context: context,
    ));

    return results;
  }
}
