import '../filesystem/generation_result.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates or updates the Material 3 theme layer.
class ThemeGenerator extends BaseGenerator {
  ThemeGenerator({
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
    final context = <String, dynamic>{};

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

    return results;
  }
}
