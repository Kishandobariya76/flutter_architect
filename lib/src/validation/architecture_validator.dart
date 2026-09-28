import 'dart:io';
import 'package:path/path.dart' as p;
import '../configuration/config_resolver.dart';
import '../naming/naming_utils.dart';
import '../utils/pubspec_utils.dart';
import 'validation_result.dart';

/// Validates Clean Architecture structural boundaries, conventions, and configuration.
class ArchitectureValidator {
  final Directory projectDir;

  ArchitectureValidator([Directory? projectDir])
      : projectDir = projectDir ?? Directory.current;

  ArchitectureValidationResult validate() {
    final issues = <ValidationIssue>[];

    // 1. Pubspec check
    final pubspec = PubspecUtils.findPubspec(projectDir);
    if (pubspec == null) {
      issues.add(const ValidationIssue(
        message: 'Could not find pubspec.yaml in current or parent directory.',
        severity: ValidationSeverity.error,
        fixHint:
            'Ensure you run flutter-architect inside a Dart/Flutter project.',
      ));
      return ArchitectureValidationResult(issues);
    }

    // 2. Configuration check
    final configFile = ConfigResolver.findConfigFile(projectDir);
    if (configFile == null) {
      issues.add(const ValidationIssue(
        message: 'Configuration file flutter_architect.yaml is missing.',
        severity: ValidationSeverity.warning,
        fixHint:
            'Run "flutter-architect init" to generate project configuration.',
      ));
    }

    // 3. Core infrastructure check
    final coreDir = Directory(p.join(projectDir.path, 'lib', 'core'));
    if (!coreDir.existsSync()) {
      issues.add(const ValidationIssue(
        message: 'Missing core directory: lib/core',
        severity: ValidationSeverity.warning,
        fixHint: 'Run "flutter-architect init" to scaffold core architecture.',
      ));
    } else {
      final requiredCoreSubdirs = ['error', 'theme', 'network'];
      for (final sub in requiredCoreSubdirs) {
        final subDir = Directory(p.join(coreDir.path, sub));
        if (!subDir.existsSync()) {
          issues.add(ValidationIssue(
            message: 'Missing standard core module: lib/core/$sub',
            severity: ValidationSeverity.warning,
            path: subDir.path,
          ));
        }
      }
    }

    // 4. Feature structure & naming checks
    final featuresDir = Directory(p.join(projectDir.path, 'lib', 'features'));
    if (featuresDir.existsSync()) {
      final featureEntities = featuresDir.listSync().whereType<Directory>();
      for (final featDir in featureEntities) {
        final featName = p.basename(featDir.path);

        // Naming check
        final expectedSnake = NamingUtils.toSnakeCase(featName);
        if (featName != expectedSnake) {
          issues.add(ValidationIssue(
            message:
                'Feature folder "$featName" does not follow snake_case convention.',
            severity: ValidationSeverity.error,
            path: featDir.path,
            fixHint: 'Rename to "$expectedSnake".',
          ));
        }

        // Entities check (entities folder forbidden by default)
        final entitiesDir =
            Directory(p.join(featDir.path, 'domain', 'entities'));
        if (entitiesDir.existsSync()) {
          issues.add(ValidationIssue(
            message:
                'Forbidden "entities" folder detected in feature "$featName".',
            severity: ValidationSeverity.warning,
            path: entitiesDir.path,
            fixHint:
                'Entities folder is disabled by default in Flutter Architect clean architecture.',
          ));
        }

        // Clean architecture layer checks
        final dataDir = Directory(p.join(featDir.path, 'data'));
        final domainDir = Directory(p.join(featDir.path, 'domain'));
        final presDir = Directory(p.join(featDir.path, 'presentation'));

        if (!dataDir.existsSync()) {
          issues.add(ValidationIssue(
            message: 'Feature "$featName" is missing data layer.',
            severity: ValidationSeverity.warning,
            path: dataDir.path,
          ));
        }
        if (!domainDir.existsSync()) {
          issues.add(ValidationIssue(
            message: 'Feature "$featName" is missing domain layer.',
            severity: ValidationSeverity.warning,
            path: domainDir.path,
          ));
        }
        if (!presDir.existsSync()) {
          issues.add(ValidationIssue(
            message: 'Feature "$featName" is missing presentation layer.',
            severity: ValidationSeverity.warning,
            path: presDir.path,
          ));
        }

        // Layer boundaries check
        if (domainDir.existsSync()) {
          _checkDomainBoundaries(domainDir, issues);
        }
      }
    }

    return ArchitectureValidationResult(issues);
  }

  void _checkDomainBoundaries(
      Directory domainDir, List<ValidationIssue> issues) {
    final domainFiles = domainDir.listSync(recursive: true).whereType<File>();
    for (final file in domainFiles) {
      if (!file.path.endsWith('.dart')) continue;

      try {
        final content = file.readAsStringSync();
        // Domain must not depend on presentation
        if (content.contains('/presentation/')) {
          issues.add(ValidationIssue(
            message:
                'Architecture violation: Domain file imports presentation layer.',
            severity: ValidationSeverity.error,
            path: file.path,
            fixHint:
                'Domain must be pure and independent of presentation widgets or state.',
          ));
        }
        // Domain must not depend on flutter UI widgets
        if (content.contains("import 'package:flutter/material.dart';") ||
            content.contains("import 'package:flutter/widgets.dart';")) {
          issues.add(ValidationIssue(
            message:
                'Architecture violation: Domain file imports Flutter UI framework.',
            severity: ValidationSeverity.error,
            path: file.path,
            fixHint:
                'Domain models and use cases should remain framework-agnostic.',
          ));
        }
      } catch (_) {}
    }
  }
}
