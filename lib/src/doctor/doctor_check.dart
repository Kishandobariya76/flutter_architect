/// Status of an individual diagnostic check.
enum CheckStatus {
  passed,
  warning,
  failed,
}

/// Result of a single doctor diagnostic check.
class DoctorCheck {
  final String title;
  final CheckStatus status;
  final String? details;
  final String? resolution;

  const DoctorCheck({
    required this.title,
    required this.status,
    this.details,
    this.resolution,
  });

  bool get isPassed => status == CheckStatus.passed;
  bool get isWarning => status == CheckStatus.warning;
  bool get isFailed => status == CheckStatus.failed;
}
