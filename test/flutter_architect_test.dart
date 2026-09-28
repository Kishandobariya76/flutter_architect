import 'package:flutter_architecture_kit/flutter_architecture_kit.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterArchitectCommandRunner', () {
    test('returns version on --version flag', () async {
      final runner = FlutterArchitectCommandRunner();
      final code = await runner.run(['--version']);
      expect(code, equals(ExitCodes.success));
    });

    test('returns version on version command', () async {
      final runner = FlutterArchitectCommandRunner();
      final code = await runner.run(['version']);
      expect(code, equals(ExitCodes.success));
    });

    test('returns usage code on invalid command', () async {
      final runner = FlutterArchitectCommandRunner();
      final code = await runner.run(['non_existent_command']);
      expect(code, equals(ExitCodes.usage));
    });
  });
}
