/// Status of a file generation attempt.
enum GenerationStatus {
  created,
  overwritten,
  skipped,
  dryRun,
}

/// Details of a single generated file.
class FileGenerationResult {
  final String path;
  final GenerationStatus status;
  final String? reason;

  const FileGenerationResult({
    required this.path,
    required this.status,
    this.reason,
  });

  bool get isCreated => status == GenerationStatus.created;
  bool get isOverwritten => status == GenerationStatus.overwritten;
  bool get isSkipped => status == GenerationStatus.skipped;
  bool get isDryRun => status == GenerationStatus.dryRun;
}
