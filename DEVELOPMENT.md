# Development Guide for Flutter Architect

This guide explains how to develop, test, debug, and extend `flutter_architect`.

---

## 🛠️ Local Environment Setup

1. Ensure Dart 3.0+ and Flutter 3.0+ are installed:
   ```bash
   dart --version
   flutter --version
   ```
2. Clone and fetch dependencies:
   ```bash
   git clone https://github.com/Kishandobariya76/flutter_architect.git
   cd flutter_architect
   dart pub get
   ```

---

## 💻 Running the CLI Locally

You can run the CLI directly from source using `dart run`:

```bash
dart run bin/flutter_architect.dart --help
dart run bin/flutter_architect.dart doctor
dart run bin/flutter_architect.dart init --help
```

To test global activation from your local clone:

```bash
# Activate from local directory
dart pub global activate --source path .

# Test global executable
flutter-architect --version
flutter-architect doctor
```

To deactivate when finished:
```bash
dart pub global deactivate flutter_architect
```

---

## 🧪 Running Tests & Quality Checks

Run the automated test suite:
```bash
dart test
```

Run static analysis:
```bash
dart analyze
```

Format code:
```bash
dart format .
```

Verify pub.dev publishing rules:
```bash
dart pub publish --dry-run
```

---

## ➕ How to Add a New Command

Adding a new command (for example: `flutter-architect service payment`) requires only 4 straightforward steps:

### Step 1: Create the Template
Add the template string to `lib/src/templates/template_registry.dart`:
```dart
static const String serviceTemplate = '''
class {{name_pascal}}Service {
  Future<void> execute() async {
    // Generated implementation
  }
}
''';
```

### Step 2: Create the Generator
Create `lib/src/generators/service_generator.dart`:
```dart
import '../filesystem/generation_result.dart';
import '../naming/naming_utils.dart';
import '../templates/template_registry.dart';
import 'base_generator.dart';

class ServiceGenerator extends BaseGenerator {
  final String name;

  ServiceGenerator({
    required this.name,
    required super.fileManager,
    required super.config,
    super.projectDir,
    super.dryRun,
    super.force,
    super.skipExisting,
  });

  @override
  Future<List<FileGenerationResult>> generate() async {
    final snake = NamingUtils.toSnakeCase(name);
    final pascal = NamingUtils.toPascalCase(name);

    final result = renderAndWrite(
      relativePath: 'lib/services/\${snake}_service.dart',
      templateName: 'service.dart',
      defaultContent: TemplateRegistry.serviceTemplate,
      context: {
        'name_snake': snake,
        'name_pascal': pascal,
      },
    );

    return [result];
  }
}
```

### Step 3: Create the Command
Create `lib/src/commands/service_command.dart`:
```dart
import '../cli/base_command.dart';
import '../cli/exit_codes.dart';
import '../generators/service_generator.dart';

class ServiceCommand extends BaseCommand {
  @override
  final String name = 'service';

  @override
  final String description = 'Generate a standalone service class.';

  @override
  String get invocation => 'flutter-architect service <name> [options]';

  ServiceCommand({super.logger, super.prompts, super.projectDir});

  @override
  Future<int> run() async {
    final serviceName = requireNameArg(label: 'service_name');

    logger.step('Generating Service: \$serviceName');

    final generator = ServiceGenerator(
      name: serviceName,
      fileManager: fileManager,
      config: projectConfig,
      projectDir: projectDir,
      dryRun: dryRun,
      force: force,
      skipExisting: skipExisting,
    );

    final results = await generator.generate();
    logger.success('Service "\$serviceName" generated with \${results.length} file.');
    return ExitCodes.success;
  }
}
```

### Step 4: Register the Command
Open `lib/src/cli/command_runner.dart` and register the new command:
```dart
addCommand(ServiceCommand(logger: logger, prompts: prompts, projectDir: projectDir));
```

Export the new classes in `lib/flutter_architect.dart`, add unit tests in `test/`, and document the command in `README.md`!

---

## 🚀 Release Process

1. Verify tests and code quality:
   ```bash
   dart test
   dart analyze
   dart format --output=none --set-exit-if-changed .
   ```
2. Update version in `pubspec.yaml` and `lib/src/commands/version_command.dart`.
3. Document release changes in `CHANGELOG.md`.
4. Validate packaging with dry-run:
   ```bash
   dart pub publish --dry-run
   ```
5. Publish to pub.dev (explicit manual execution):
   ```bash
   dart pub publish
   ```
