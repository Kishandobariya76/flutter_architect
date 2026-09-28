import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates Flutter localization structure (l10n.yaml, English and Spanish ARB files).
class LocalizationGenerator extends BaseGenerator {
  LocalizationGenerator({
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
    final context = {
      'app_title': NamingUtils.toTitleCase(packageName),
    };

    results.add(renderAndWrite(
      relativePath: 'l10n.yaml',
      templateName: 'l10n.yaml',
      defaultContent: TemplateRegistry.l10nYaml,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/l10n/app_en.arb',
      templateName: 'app_en.arb',
      defaultContent: TemplateRegistry.arbEn,
      context: context,
    ));

    results.add(renderAndWrite(
      relativePath: 'lib/l10n/app_es.arb',
      templateName: 'app_es.arb',
      defaultContent: TemplateRegistry.arbEs,
      context: context,
    ));

    return results;
  }
}
