# Flutter Architect Example

This directory demonstrates both CLI and programmatic usage of `flutter_architect`.

## 1. CLI Usage

Activate Flutter Architect globally:

```bash
dart pub global activate flutter_architect
```

Initialize a new Flutter project with Clean Architecture:

```bash
flutter create my_awesome_app
cd my_awesome_app
flutter-architect init
```

Generate features and architecture components:

```bash
# Generate complete Clean Architecture feature
flutter-architect feature auth

# Generate state management
flutter-architect bloc cart
flutter-architect cubit settings

# Generate domain & data layers
flutter-architect model user
flutter-architect repository order
flutter-architect datasource order
flutter-architect usecase checkout

# Generate Material 3 UI components
flutter-architect page profile
flutter-architect widget product_card
flutter-architect dialog confirmation
flutter-architect bottomsheet filter

# Generate API slice
flutter-architect api login --method post

# Run diagnostics and validation
flutter-architect doctor
flutter-architect validate
```

## 2. Programmatic Usage

See `flutter_architect_example.dart` for how to invoke `NamingUtils`, `TemplateEngine`, `ProjectConfig`, and `FlutterArchitectCommandRunner` from your own Dart scripts.
