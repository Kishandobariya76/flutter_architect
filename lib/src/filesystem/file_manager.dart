import 'dart:io';
import 'package:path/path.dart' as p;
import '../cli/logger.dart';
import '../cli/prompts.dart';
import 'generation_result.dart';

/// Centralized file operations manager with safe collision handling and dry-run support.
class FileManager {
  final Logger logger;
  final Prompts prompts;
  final Directory baseDir;

  FileManager({
    Logger? logger,
    Prompts? prompts,
    Directory? baseDir,
  })  : logger = logger ?? Logger(),
        prompts = prompts ?? Prompts(),
        baseDir = baseDir ?? Directory.current;

  /// Writes [content] to [relativePath] with safety checks and dry-run awareness.
  FileGenerationResult writeFile({
    required String relativePath,
    required String content,
    bool dryRun = false,
    bool force = false,
    bool skipExisting = false,
  }) {
    final fullPath = p.normalize(p.join(baseDir.path, relativePath));
    final file = File(fullPath);

    if (dryRun) {
      logger.dryRun('Would create: $relativePath');
      return FileGenerationResult(
        path: relativePath,
        status: GenerationStatus.dryRun,
        reason: 'Dry run requested',
      );
    }

    if (file.existsSync()) {
      final action = prompts.resolveConflict(
        filePath: relativePath,
        force: force,
        skipExisting: skipExisting,
      );

      if (action == FileConflictAction.skip) {
        logger.detail('Skipping existing file: $relativePath');
        return FileGenerationResult(
          path: relativePath,
          status: GenerationStatus.skipped,
          reason: 'File already exists and skip was chosen',
        );
      }

      // Overwrite
      file.writeAsStringSync(content);
      logger.success('Overwritten $relativePath');
      return FileGenerationResult(
        path: relativePath,
        status: GenerationStatus.overwritten,
      );
    }

    // Create directories if missing
    final parent = file.parent;
    if (!parent.existsSync()) {
      parent.createSync(recursive: true);
    }

    file.writeAsStringSync(content);
    logger.success('Created $relativePath');
    return FileGenerationResult(
      path: relativePath,
      status: GenerationStatus.created,
    );
  }

  /// Checks if a file exists relative to baseDir.
  bool exists(String relativePath) {
    return File(p.join(baseDir.path, relativePath)).existsSync();
  }

  /// Reads a file relative to baseDir.
  String? readFile(String relativePath) {
    final file = File(p.join(baseDir.path, relativePath));
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return null;
  }
}
