import 'dart:io';

/// Platform and process utilities ensuring safe cross-platform execution.
class PlatformUtils {
  PlatformUtils._();

  static bool get isWindows => Platform.isWindows;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isLinux => Platform.isLinux;

  /// Returns the executable name for flutter depending on operating system.
  static String get flutterCommand => isWindows ? 'flutter.bat' : 'flutter';

  /// Returns the executable name for dart depending on operating system.
  static String get dartCommand => isWindows ? 'dart.exe' : 'dart';

  /// Checks if a command can be executed in the current environment PATH.
  static Future<bool> isCommandAvailable(String command) async {
    try {
      final checkCmd = isWindows ? 'where' : 'which';
      final result = await Process.run(checkCmd, [command], runInShell: true);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Runs a command and returns the standard output or null if failed.
  static Future<String?> runProcess(String executable, List<String> arguments,
      {String? workingDir}) async {
    try {
      final result = await Process.run(executable, arguments,
          workingDirectory: workingDir, runInShell: true);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
