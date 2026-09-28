import '../filesystem/generation_result.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

/// Generates Firebase setup service and guides developer on configuration.
class FirebaseGenerator extends BaseGenerator {
  FirebaseGenerator({
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

    results.add(renderAndWrite(
      relativePath: 'lib/core/firebase/firebase_service.dart',
      templateName: 'firebase_service.dart',
      defaultContent: TemplateRegistry.firebaseService,
      context: {},
    ));

    return results;
  }
}
