import 'dart:io';
import 'package:flutter_architect/flutter_architect.dart';
import 'package:test/test.dart';

void main() {
  group('CLI Integration Workflow', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fa_integ_');
      // Create valid pubspec.yaml
      File('${tempDir.path}/pubspec.yaml').writeAsStringSync('''
name: my_test_app
description: A test Flutter app.
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  dio: ^5.4.0
  get_it: ^7.6.0
''');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('executes init command non-interactively', () async {
      final runner = FlutterArchitectCommandRunner(
        customProjectDir: tempDir,
        customPrompts: Prompts(forceInteractive: false),
      );

      final code = await runner.run([
        'init',
        '--architecture',
        'clean',
        '--state-management',
        'bloc',
        '--network',
        'dio',
        '--di',
        'get_it',
        '--theme',
        'material3',
        '--no-example-feature',
        '--force',
      ]);

      expect(code, equals(ExitCodes.success));
      expect(
          File('${tempDir.path}/flutter_architect.yaml').existsSync(), isTrue);
      expect(File('${tempDir.path}/lib/core/error/failures.dart').existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/injection/injection_container.dart')
              .existsSync(),
          isTrue);
    });

    test('executes feature generation command', () async {
      final runner = FlutterArchitectCommandRunner(
        customProjectDir: tempDir,
        customPrompts: Prompts(forceInteractive: false),
      );

      // 1. Init project
      await runner.run([
        'init',
        '--architecture',
        'clean',
        '--no-example-feature',
        '--force',
      ]);

      // 2. Generate feature
      final code = await runner.run(['feature', 'order']);
      expect(code, equals(ExitCodes.success));

      expect(
          File('${tempDir.path}/lib/features/order/data/models/order_model.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/order/domain/repositories/order_repository.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/order/presentation/bloc/order_bloc.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/order/presentation/pages/order_page.dart')
              .existsSync(),
          isTrue);
    });

    test('executes doctor and validate commands', () async {
      final runner = FlutterArchitectCommandRunner(
        customProjectDir: tempDir,
        customPrompts: Prompts(forceInteractive: false),
      );

      // 1. Init project
      await runner.run([
        'init',
        '--architecture',
        'clean',
        '--no-example-feature',
        '--force',
      ]);

      // 2. Run doctor
      final doctorCode = await runner.run(['doctor']);
      expect(doctorCode, equals(ExitCodes.success));

      // 3. Run validate
      final validateCode = await runner.run(['validate']);
      expect(validateCode, equals(ExitCodes.success));
    });

    test('dry run does not create files', () async {
      final runner = FlutterArchitectCommandRunner(
        customProjectDir: tempDir,
        customPrompts: Prompts(forceInteractive: false),
      );

      final code = await runner.run(['feature', 'payment', '--dry-run']);
      expect(code, equals(ExitCodes.success));
      expect(Directory('${tempDir.path}/lib/features/payment').existsSync(),
          isFalse);
    });
  });
}
