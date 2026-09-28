/// Standard CLI exit codes based on BSD sysexits conventions.
class ExitCodes {
  ExitCodes._();

  /// Execution completed successfully.
  static const int success = 0;

  /// Generic failure or runtime exception.
  static const int failure = 1;

  /// Command line usage error (invalid flags, missing arguments).
  static const int usage = 64;

  /// Invalid project state or missing required files.
  static const int dataError = 65;

  /// Missing dependency or missing external tool.
  static const int unavailable = 69;

  /// Internal software or generator bug.
  static const int software = 70;

  /// File system or permission error.
  static const int ioError = 74;

  /// Configuration file format or validation error.
  static const int config = 78;
}
