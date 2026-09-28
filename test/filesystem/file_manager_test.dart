import 'dart:io';
import 'package:flutter_architecture_kit/flutter_architecture_kit.dart';
import 'package:test/test.dart';

void main() {
  group('FileManager', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fa_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('writes file and creates parent folders', () {
      final fm = FileManager(baseDir: tempDir);
      final res = fm.writeFile(
        relativePath: 'lib/core/test.dart',
        content: '// test content',
      );

      expect(res.status, equals(GenerationStatus.created));
      expect(File('${tempDir.path}/lib/core/test.dart').existsSync(), isTrue);
      expect(File('${tempDir.path}/lib/core/test.dart').readAsStringSync(),
          equals('// test content'));
    });

    test('respects dry run without modifying filesystem', () {
      final fm = FileManager(baseDir: tempDir);
      final res = fm.writeFile(
        relativePath: 'lib/dry_run_file.dart',
        content: '// test',
        dryRun: true,
      );

      expect(res.status, equals(GenerationStatus.dryRun));
      expect(
          File('${tempDir.path}/lib/dry_run_file.dart').existsSync(), isFalse);
    });

    test('skips existing file when skipExisting is true', () {
      final fm = FileManager(baseDir: tempDir);
      fm.writeFile(
        relativePath: 'lib/existing.dart',
        content: 'original',
      );

      final second = fm.writeFile(
        relativePath: 'lib/existing.dart',
        content: 'updated',
        skipExisting: true,
      );

      expect(second.status, equals(GenerationStatus.skipped));
      expect(File('${tempDir.path}/lib/existing.dart').readAsStringSync(),
          equals('original'));
    });

    test('overwrites existing file when force is true', () {
      final fm = FileManager(baseDir: tempDir);
      fm.writeFile(
        relativePath: 'lib/existing.dart',
        content: 'original',
      );

      final second = fm.writeFile(
        relativePath: 'lib/existing.dart',
        content: 'updated',
        force: true,
      );

      expect(second.status, equals(GenerationStatus.overwritten));
      expect(File('${tempDir.path}/lib/existing.dart').readAsStringSync(),
          equals('updated'));
    });
  });
}
