import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates an end-to-end API integration stack (datasource, response model, repository, usecase, bloc).
class ApiGenerator extends BaseGenerator {
  final String name;
  final String method;

  ApiGenerator({
    required this.name,
    this.method = 'get',
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
    final methodUpper = method.toUpperCase();
    final methodLower = method.toLowerCase();
    final hasBody =
        methodLower == 'post' || methodLower == 'put' || methodLower == 'patch';

    final context = {
      'name': snake,
      'name_pascal': pascal,
      'name_camel': camel,
      'name_title': title,
      'method': methodUpper,
      'method_lower': methodLower,
      'has_body': hasBody,
      'feature_name': snake,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'feature_title': title,
    };

    final basePath = 'lib/features/$snake';

    // 1. Response Model
    results.add(renderAndWrite(
      relativePath: '$basePath/data/models/${snake}_response_model.dart',
      templateName: 'api_response_model.dart',
      defaultContent: TemplateRegistry.apiResponseModel,
      context: context,
    ));

    // 2. Remote Datasource
    results.add(renderAndWrite(
      relativePath:
          '$basePath/data/datasources/${snake}_remote_datasource.dart',
      templateName: 'api_datasource.dart',
      defaultContent: TemplateRegistry.apiDatasource,
      context: context,
    ));

    // 3. Domain Repository
    results.add(renderAndWrite(
      relativePath: '$basePath/domain/repositories/${snake}_repository.dart',
      templateName: 'api_repository.dart',
      defaultContent: TemplateRegistry.apiRepository,
      context: context,
    ));

    // 4. Data Repository Implementation
    results.add(renderAndWrite(
      relativePath: '$basePath/data/repositories/${snake}_repository_impl.dart',
      templateName: 'api_repository_impl.dart',
      defaultContent: TemplateRegistry.apiRepositoryImpl,
      context: context,
    ));

    // 5. UseCase
    results.add(renderAndWrite(
      relativePath: '$basePath/domain/usecases/${snake}_usecase.dart',
      templateName: 'api_usecase.dart',
      defaultContent: TemplateRegistry.apiUseCase,
      context: context,
    ));

    // 6. BLoC Presentation
    results.add(renderAndWrite(
      relativePath: '$basePath/presentation/bloc/${snake}_event.dart',
      templateName: 'api_bloc_event.dart',
      defaultContent: TemplateRegistry.apiBlocEvent,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$basePath/presentation/bloc/${snake}_state.dart',
      templateName: 'api_bloc_state.dart',
      defaultContent: TemplateRegistry.apiBlocState,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '$basePath/presentation/bloc/${snake}_bloc.dart',
      templateName: 'api_bloc.dart',
      defaultContent: TemplateRegistry.apiBloc,
      context: context,
    ));

    return results;
  }
}
