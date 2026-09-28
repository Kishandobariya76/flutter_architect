import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Utilities for locating, inspecting, and manipulating `pubspec.yaml`.
class PubspecUtils {
  PubspecUtils._();

  /// Locates `pubspec.yaml` in [startDir] or its parent directories.
  static File? findPubspec([Directory? startDir]) {
    var dir = startDir ?? Directory.current;
    while (true) {
      final file = File(p.join(dir.path, 'pubspec.yaml'));
      if (file.existsSync()) {
        return file;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break; // reached filesystem root
      }
      dir = parent;
    }
    return null;
  }

  /// Parses `pubspec.yaml` in [projectDir] into a YAML map.
  static YamlMap? readPubspecYaml([Directory? projectDir]) {
    final file = findPubspec(projectDir);
    if (file == null) return null;
    try {
      final content = file.readAsStringSync();
      final doc = loadYaml(content);
      if (doc is YamlMap) return doc;
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Retrieves the package name defined in `pubspec.yaml`.
  /// Defaults to 'my_app' if not found.
  static String getPackageName([Directory? projectDir]) {
    final yaml = readPubspecYaml(projectDir);
    if (yaml != null && yaml['name'] is String) {
      return yaml['name'] as String;
    }
    return 'my_app';
  }

  /// Checks if current directory contains a valid Flutter project.
  static bool isFlutterProject([Directory? projectDir]) {
    final yaml = readPubspecYaml(projectDir);
    if (yaml == null) return false;

    // Checks dependencies for flutter
    final deps = yaml['dependencies'];
    if (deps is YamlMap && deps.containsKey('flutter')) {
      return true;
    }

    // Checks flutter section
    if (yaml.containsKey('flutter')) {
      return true;
    }

    return false;
  }

  /// Checks if a specific dependency is declared in `pubspec.yaml`.
  static bool hasDependency(String name, [Directory? projectDir]) {
    final yaml = readPubspecYaml(projectDir);
    if (yaml == null) return false;
    final deps = yaml['dependencies'];
    if (deps is YamlMap && deps.containsKey(name)) {
      return true;
    }
    final devDeps = yaml['dev_dependencies'];
    if (devDeps is YamlMap && devDeps.containsKey(name)) {
      return true;
    }
    return false;
  }

  /// Retrieves the Flutter SDK constraint or environment from `pubspec.yaml`.
  static String? getSdkConstraint([Directory? projectDir]) {
    final yaml = readPubspecYaml(projectDir);
    if (yaml == null) return null;
    final env = yaml['environment'];
    if (env is YamlMap && env['sdk'] is String) {
      return env['sdk'] as String;
    }
    return null;
  }
}
