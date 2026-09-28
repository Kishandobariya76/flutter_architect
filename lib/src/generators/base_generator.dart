import 'dart:io';
import '../configuration/project_config.dart';
import '../filesystem/file_manager.dart';
import '../filesystem/generation_result.dart';
import '../templates/template_engine.dart';
import '../utils/pubspec_utils.dart';

/// Base contract for all code and structure generators.
abstract class BaseGenerator {
  final FileManager fileManager;
  final ProjectConfig config;
  final Directory projectDir;
  final bool dryRun;
  final bool force;
  final bool skipExisting;

  BaseGenerator({
    required this.fileManager,
    required this.config,
    Directory? projectDir,
    this.dryRun = false,
    this.force = false,
    this.skipExisting = false,
  }) : projectDir = projectDir ?? Directory.current;

  /// Retrieves the Flutter app package name from `pubspec.yaml`.
  String get packageName => PubspecUtils.getPackageName(projectDir);

  /// Helper to render and safely write a template.
  FileGenerationResult renderAndWrite({
    required String relativePath,
    required String templateName,
    required String defaultContent,
    required Map<String, dynamic> context,
  }) {
    final rawTemplate = TemplateEngine.resolveTemplate(
      templateName: templateName,
      defaultContent: defaultContent,
      customPath: config.customTemplatePath,
      projectDir: projectDir,
    );

    // Inject standard global context values
    final mergedContext = <String, dynamic>{
      'package_name': packageName,
      ...context,
    };

    final content = TemplateEngine.render(rawTemplate, mergedContext);

    return fileManager.writeFile(
      relativePath: relativePath,
      content: content,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );
  }

  /// Executes the generator.
  Future<List<FileGenerationResult>> generate();
}
