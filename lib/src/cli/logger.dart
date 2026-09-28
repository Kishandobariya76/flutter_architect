import 'dart:io';

/// Professional CLI logger supporting ANSI coloring, no-color mode, and clean icons.
class Logger {
  final bool enableColor;
  final IOSink _out;
  final IOSink _err;

  Logger({
    bool? enableColor,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  })  : enableColor = enableColor ??
            (stdout.hasTerminal && Platform.environment['TERM'] != 'dumb'),
        _out = stdoutSink ?? stdout,
        _err = stderrSink ?? stderr;

  // ANSI color escapes
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _dim = '\x1B[2m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';

  String _colorize(String text, String code) =>
      enableColor ? '$code$text$_reset' : text;

  void info(String message) {
    _out.writeln(message);
  }

  void success(String message) {
    _out.writeln('${_colorize('✓', _green)} $message');
  }

  void warning(String message) {
    _out.writeln('${_colorize('⚠', _yellow)} ${_colorize(message, _yellow)}');
  }

  void error(String message) {
    _err.writeln('${_colorize('✗', _red)} ${_colorize(message, _red)}');
  }

  void detail(String message) {
    _out.writeln(_colorize('  $message', _dim));
  }

  void highlight(String message) {
    _out.writeln(_colorize(message, _cyan));
  }

  void title(String message) {
    _out.writeln(_colorize('$_bold$message', _blue));
  }

  void step(String message) {
    _out.writeln('${_colorize('➜', _cyan)} $message');
  }

  void dryRun(String message) {
    _out.writeln('${_colorize('[DRY RUN]', _magenta)} $message');
  }

  void divider() {
    _out.writeln(_colorize('─' * 60, _dim));
  }
}
