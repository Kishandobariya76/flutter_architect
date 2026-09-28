import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates reusable Material 3 modal bottom sheets.
class BottomSheetGenerator extends BaseGenerator {
  final String name;
  final String? featureName;

  BottomSheetGenerator({
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
    final snake = NamingUtils.toSnakeCase(name);
    final pascal = NamingUtils.toPascalCase(name);
    final camel = NamingUtils.toCamelCase(name);
    final title = NamingUtils.toTitleCase(name);

    final context = {
      'name': snake,
      'name_pascal': pascal,
      'name_camel': camel,
      'name_title': title,
    };

    final dirPath = featureName != null
        ? 'lib/features/${NamingUtils.toSnakeCase(featureName!)}/presentation/bottomsheets'
        : 'lib/presentation/bottomsheets';

    final result = renderAndWrite(
      relativePath: '$dirPath/${snake}_bottom_sheet.dart',
      templateName: 'standalone_bottomsheet.dart',
      defaultContent: TemplateRegistry.standaloneBottomSheet,
      context: context,
    );

    return [result];
  }
}
