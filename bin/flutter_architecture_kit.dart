import 'dart:io';
import 'package:flutter_architecture_kit/src/cli/command_runner.dart';
import 'package:flutter_architecture_kit/src/cli/logger.dart';

Future<void> main(List<String> arguments) async {
  final noColor = arguments.contains('--no-color');
  final logger = Logger(enableColor: !noColor);

  final runner = FlutterArchitectCommandRunner(customLogger: logger);
  final exitCode = await runner.run(arguments);
  exit(exitCode);
}
