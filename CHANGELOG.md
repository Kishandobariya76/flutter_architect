# Changelog

All notable changes to `flutter_architecture_kit` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-28

### Added
- Complete rewrite with modular architecture, robust CLI CommandRunner, and extensible generator pipeline.
- Production Clean Architecture + BLoC + Feature-first scaffolding (`flutter-architect init`).
- Removed `entities/` folder by default to prevent boilerplate duplication.
- Project diagnostic command (`flutter-architect doctor`) checking Dart/Flutter SDKs, pubspec, dependencies, and configuration.
- Architectural rule & boundary validation command (`flutter-architect validate`) for local and CI/CD environments.
- Feature generator (`flutter-architect feature <name>`) scaffolding full data, domain, and presentation layers.
- Isolated module generator (`flutter-architect module <name>`).
- Modern state management generators:
  - `flutter-architect bloc <name>` (Bloc, Event, State)
  - `flutter-architect cubit <name>` (Cubit, State)
- Data and domain generators:
  - `flutter-architect model <name>` with JSON serialization and immutable `copyWith`
  - `flutter-architect repository <name>` (domain interface and data implementation)
  - `flutter-architect datasource <name>` (remote and local cache sources)
  - `flutter-architect usecase <name>` (callable domain usecase)
- Material 3 UI component generators:
  - `flutter-architect page <name>`
  - `flutter-architect widget <name>`
  - `flutter-architect dialog <name>`
  - `flutter-architect bottomsheet <name>`
- End-to-end API generator (`flutter-architect api <name> --method [get|post|put|patch|delete]`).
- API endpoint registration (`flutter-architect endpoint <name>`).
- Utility & infrastructure generators:
  - `flutter-architect theme` (Material 3 tokens, colors, text styles, theme modes)
  - `flutter-architect localization` (l10n.yaml, English and Spanish ARBs)
  - `flutter-architect flavors` (development, staging, production entrypoints and configs)
  - `flutter-architect firebase` (Firebase service boilerplate and setup documentation)
- Safe file generation with `--force`, `--skip-existing`, interactive conflict resolution, and `--dry-run` preview.
- Robust naming utility (`NamingUtils`) supporting kebab-case, snake_case, PascalCase, camelCase, Title Case, and CONSTANT_CASE.
- Clean package-relative import management without fragile relative path chains.
- Cross-platform support for macOS, Linux, and Windows.
- Full unit, generator, and integration test suite.
