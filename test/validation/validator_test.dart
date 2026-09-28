import 'dart:io';
import 'package:flutter_architect/flutter_architect.dart';
import 'package:test/test.dart';

void main() {
  group('ArchitectureValidator', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fa_val_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('flags missing pubspec.yaml', () {
      final validator = ArchitectureValidator(tempDir);
      final result = validator.validate();

      expect(result.isValid, isFalse);
      expect(result.errorCount, greaterThanOrEqualTo(1));
      expect(result.issues.first.message, contains('pubspec.yaml'));
    });

    test('flags forbidden entities directory', () {
      // Create minimal project
      File('${tempDir.path}/pubspec.yaml')
          .writeAsStringSync('name: test_app\n');
      final entitiesDir =
          Directory('${tempDir.path}/lib/features/login/domain/entities');
      entitiesDir.createSync(recursive: true);

      final validator = ArchitectureValidator(tempDir);
      final result = validator.validate();

      expect(result.issues.any((i) => i.message.contains('entities')), isTrue);
    });

    test('flags domain layer importing presentation', () {
      File('${tempDir.path}/pubspec.yaml')
          .writeAsStringSync('name: test_app\n');
      final domainFile = File(
          '${tempDir.path}/lib/features/auth/domain/repositories/auth_repo.dart');
      domainFile.parent.createSync(recursive: true);
      domainFile.writeAsStringSync(
          "import '../presentation/pages/auth_page.dart';\n");

      final validator = ArchitectureValidator(tempDir);
      final result = validator.validate();

      expect(
          result.issues
              .any((i) => i.message.contains('imports presentation layer')),
          isTrue);
    });
  });
}
