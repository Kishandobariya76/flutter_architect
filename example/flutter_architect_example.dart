import 'package:flutter_architect/flutter_architect.dart';

void main() async {
  // 1. Programmatic Naming Utilities
  final featureName = 'user-profile';
  print('Feature snake_case: ${NamingUtils.toSnakeCase(featureName)}');
  print('Feature PascalCase: ${NamingUtils.toPascalCase(featureName)}');
  print('Feature camelCase:  ${NamingUtils.toCamelCase(featureName)}');

  // 2. Programmatic Template Rendering
  const template = 'Hello {{name}}! Welcome to {{architecture}}.';
  final rendered = TemplateEngine.render(template, {
    'name': 'Developer',
    'architecture': 'Clean Architecture + BLoC',
  });
  print('Rendered: $rendered');

  // 3. Inspect Project Configuration
  final config = ProjectConfig.defaultConfig();
  print('Default Architecture: ${config.architecture.value}');
  print('Default State Management: ${config.stateManagement.value}');

  // 4. Run CLI Runner Programmatically
  final runner = FlutterArchitectCommandRunner();
  await runner.run(['--version']);
}
