import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'project_config.dart';

/// Resolves configuration taking into account CLI overrides, project file, and defaults.
class ConfigResolver {
  static const String configFileName = 'flutter_architect.yaml';

  /// Finds `flutter_architect.yaml` in [startDir] or parent directories.
  static File? findConfigFile([Directory? startDir]) {
    var dir = startDir ?? Directory.current;
    while (true) {
      final file = File(p.join(dir.path, configFileName));
      if (file.existsSync()) {
        return file;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break;
      }
      dir = parent;
    }
    return null;
  }

  /// Loads `ProjectConfig` from disk, or returns default if not found.
  static ProjectConfig loadConfig([Directory? projectDir]) {
    final file = findConfigFile(projectDir);
    if (file == null) {
      return ProjectConfig.defaultConfig();
    }

    try {
      final content = file.readAsStringSync();
      final doc = loadYaml(content);
      if (doc is YamlMap) {
        return ProjectConfig.fromMap(doc);
      }
    } catch (_) {
      // Fallback on corrupt config
    }
    return ProjectConfig.defaultConfig();
  }

  /// Writes configuration to `flutter_architect.yaml` in [targetDir].
  static File saveConfig(ProjectConfig config, [Directory? targetDir]) {
    final dir = targetDir ?? Directory.current;
    final file = File(p.join(dir.path, configFileName));
    file.writeAsStringSync(config.toYamlString());
    return file;
  }

  /// Merges project configuration with runtime CLI argument overrides.
  static ProjectConfig resolve({
    Directory? projectDir,
    String? architecture,
    String? stateManagement,
    String? networking,
    String? dependencyInjection,
    String? localStorage,
    String? theme,
    String? localization,
    String? environment,
    bool? generateEntities,
  }) {
    final base = loadConfig(projectDir);

    return base.copyWith(
      architecture: architecture != null
          ? ArchitectureType.fromString(architecture)
          : null,
      stateManagement: stateManagement != null
          ? StateManagementType.fromString(stateManagement)
          : null,
      networking:
          networking != null ? NetworkingType.fromString(networking) : null,
      dependencyInjection: dependencyInjection != null
          ? DependencyInjectionType.fromString(dependencyInjection)
          : null,
      localStorage: localStorage != null
          ? LocalStorageType.fromString(localStorage)
          : null,
      theme: theme != null ? ThemeType.fromString(theme) : null,
      localization: localization != null
          ? LocalizationType.fromString(localization)
          : null,
      environment:
          environment != null ? EnvironmentType.fromString(environment) : null,
      generateEntities: generateEntities,
    );
  }
}
