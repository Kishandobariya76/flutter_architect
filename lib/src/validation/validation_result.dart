/// Severity of an architecture validation finding.
enum ValidationSeverity {
  error,
  warning,
}

/// An individual issue found during architecture validation.
class ValidationIssue {
  final String message;
  final ValidationSeverity severity;
  final String? path;
  final String? fixHint;

  const ValidationIssue({
    required this.message,
    this.severity = ValidationSeverity.error,
    this.path,
    this.fixHint,
  });

  bool get isError => severity == ValidationSeverity.error;
  bool get isWarning => severity == ValidationSeverity.warning;
}

/// Aggregated result of project architecture validation.
class ArchitectureValidationResult {
  final List<ValidationIssue> issues;

  const ArchitectureValidationResult(this.issues);

  bool get isValid => !issues.any((i) => i.isError);
  int get errorCount => issues.where((i) => i.isError).length;
  int get warningCount => issues.where((i) => i.isWarning).length;
}
