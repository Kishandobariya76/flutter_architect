import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates the shared core infrastructure for Clean Architecture.
class CoreGenerator extends BaseGenerator {
  final bool generateMain;

  CoreGenerator({
    required super.fileManager,
    required super.config,
    super.projectDir,
    super.dryRun,
    super.force,
    super.skipExisting,
    this.generateMain = true,
  });

  @override
  Future<List<FileGenerationResult>> generate() async {
    final results = <FileGenerationResult>[];
    final appTitle = NamingUtils.toTitleCase(packageName);
    final context = {
      'app_title': appTitle,
    };

    // 1. Errors & Results
    results.add(renderAndWrite(
      relativePath: 'lib/core/error/failures.dart',
      templateName: 'core_failures.dart',
      defaultContent: TemplateRegistry.coreFailures,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/error/exceptions.dart',
      templateName: 'core_exceptions.dart',
      defaultContent: TemplateRegistry.coreExceptions,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/utils/result.dart',
      templateName: 'core_result.dart',
      defaultContent: TemplateRegistry.coreResult,
      context: context,
    ));

    // 2. Constants & Extensions
    results.add(renderAndWrite(
      relativePath: 'lib/core/constants/app_constants.dart',
      templateName: 'core_constants.dart',
      defaultContent: TemplateRegistry.coreConstants,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/extensions/context_extensions.dart',
      templateName: 'core_context_extensions.dart',
      defaultContent: TemplateRegistry.coreContextExtensions,
      context: context,
    ));

    // 3. Network layer (Dio)
    results.add(renderAndWrite(
      relativePath: 'lib/core/network/api_endpoints.dart',
      templateName: 'network_api_endpoints.dart',
      defaultContent: TemplateRegistry.networkApiEndpoints,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/network/network_info.dart',
      templateName: 'network_info.dart',
      defaultContent: TemplateRegistry.networkInfo,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/network/interceptors/error_interceptor.dart',
      templateName: 'network_error_interceptor.dart',
      defaultContent: TemplateRegistry.networkErrorInterceptor,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/network/interceptors/logging_interceptor.dart',
      templateName: 'network_logging_interceptor.dart',
      defaultContent: TemplateRegistry.networkLoggingInterceptor,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/network/dio_client.dart',
      templateName: 'network_dio_client.dart',
      defaultContent: TemplateRegistry.networkDioClient,
      context: context,
    ));

    // 4. Theme
    results.add(renderAndWrite(
      relativePath: 'lib/core/theme/app_colors.dart',
      templateName: 'theme_app_colors.dart',
      defaultContent: TemplateRegistry.themeAppColors,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/theme/app_text_styles.dart',
      templateName: 'theme_app_text_styles.dart',
      defaultContent: TemplateRegistry.themeAppTextStyles,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/theme/app_theme_mode.dart',
      templateName: 'theme_app_theme_mode.dart',
      defaultContent: TemplateRegistry.themeAppThemeMode,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/theme/app_theme.dart',
      templateName: 'theme_app_theme.dart',
      defaultContent: TemplateRegistry.themeAppTheme,
      context: context,
    ));

    // 5. Routing & Widgets
    results.add(renderAndWrite(
      relativePath: 'lib/core/routing/app_router.dart',
      templateName: 'core_router.dart',
      defaultContent: TemplateRegistry.coreRouter,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/widgets/error_view.dart',
      templateName: 'core_error_view.dart',
      defaultContent: TemplateRegistry.coreErrorView,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/core/widgets/loading_indicator.dart',
      templateName: 'core_loading_indicator.dart',
      defaultContent: TemplateRegistry.coreLoadingIndicator,
      context: context,
    ));

    // 6. Injection Container
    results.add(renderAndWrite(
      relativePath: 'lib/injection/injection_container.dart',
      templateName: 'injection_container.dart',
      defaultContent: TemplateRegistry.injectionContainer,
      context: context,
    ));

    // 7. Main entry point & smoke test (if requested)
    if (generateMain) {
      results.add(renderAndWrite(
        relativePath: 'lib/main.dart',
        templateName: 'main.dart',
        defaultContent: TemplateRegistry.mainDart,
        context: context,
      ));
      results.add(renderAndWrite(
        relativePath: 'test/widget_test.dart',
        templateName: 'widget_test.dart',
        defaultContent: TemplateRegistry.coreWidgetTest,
        context: context,
      ));
    }

    // 8. Environment files
    results.add(renderAndWrite(
      relativePath: '.env',
      templateName: 'env.dart',
      defaultContent: TemplateRegistry.envFile,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: '.env.example',
      templateName: 'env_example.dart',
      defaultContent: TemplateRegistry.envExampleFile,
      context: context,
    ));

    return results;
  }
}
