import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates build flavor setup for development, staging, and production.
class FlavorsGenerator extends BaseGenerator {
  FlavorsGenerator({
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
    final appTitle = NamingUtils.toTitleCase(packageName);

    // 1. Flavor Config Class
    results.add(renderAndWrite(
      relativePath: 'lib/flavors/flavor_config.dart',
      templateName: 'flavor_config.dart',
      defaultContent: TemplateRegistry.flavorConfig,
      context: {},
    ));

    // 2. Development entry point
    results.add(renderAndWrite(
      relativePath: 'lib/main_development.dart',
      templateName: 'main_development.dart',
      defaultContent: TemplateRegistry.mainFlavorDart,
      context: {
        'flavor_enum': 'development',
        'flavor_title': 'Dev',
        'app_title': appTitle,
        'api_base_url': 'https://dev.api.example.com/v1',
      },
    ));

    // 3. Staging entry point
    results.add(renderAndWrite(
      relativePath: 'lib/main_staging.dart',
      templateName: 'main_staging.dart',
      defaultContent: TemplateRegistry.mainFlavorDart,
      context: {
        'flavor_enum': 'staging',
        'flavor_title': 'Staging',
        'app_title': appTitle,
        'api_base_url': 'https://staging.api.example.com/v1',
      },
    ));

    // 4. Production entry point
    results.add(renderAndWrite(
      relativePath: 'lib/main_production.dart',
      templateName: 'main_production.dart',
      defaultContent: TemplateRegistry.mainFlavorDart,
      context: {
        'flavor_enum': 'production',
        'flavor_title': 'Prod',
        'app_title': appTitle,
        'api_base_url': 'https://api.example.com/v1',
      },
    ));

    // 5. Env files for flavors
    results.add(renderAndWrite(
      relativePath: '.env.dev',
      templateName: 'env_dev.dart',
      defaultContent: TemplateRegistry.envDevFile,
      context: {'app_title': appTitle},
    ));

    results.add(renderAndWrite(
      relativePath: '.env.staging',
      templateName: 'env_staging.dart',
      defaultContent: TemplateRegistry.envStagingFile,
      context: {'app_title': appTitle},
    ));

    results.add(renderAndWrite(
      relativePath: '.env.prod',
      templateName: 'env_prod.dart',
      defaultContent: TemplateRegistry.envProdFile,
      context: {'app_title': appTitle},
    ));

    return results;
  }
}
